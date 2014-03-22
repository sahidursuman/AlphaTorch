class PaymentDetail < ActiveRecord::Base
  after_commit :update_invoice
  belongs_to :invoice

  number_val_msg = 'is not a number. Amount is number dummy. We\'re all laughing at you.'
  validates_presence_of :payment_date
  validates_presence_of :invoice_id
  validates_numericality_of :cash_subtotal, if: lambda{|pd| pd.cash_subtotal}, message:number_val_msg
  validate :cash_fields_valid
  validates_numericality_of :check_subtotal, if: lambda{|pd| pd.check_subtotal}, message:number_val_msg
  validate :check_fields_valid
  validates_numericality_of :cc_subtotal, if: lambda{|pd| pd.cc_subtotal}, message:number_val_msg
  validate :credit_fields_valid
  validate :only_one_payment_type
  validate :has_payment_type
  validate :payment_less_than_amount_due

  CC_TYPES = %w(Visa Mastercard American\ Express Discover)

  def amount
    cash_subtotal + check_subtotal + cc_subtotal
  end

  private

  def only_one_payment_type
    if (cash_subtotal || cash_name).present? && (check_subtotal || check_name || check_number || check_routing).present? \
    || (cc_subtotal || cc_name || cc_processing_code).present? && (check_subtotal || check_name || check_number || check_routing).present? \
    || (cc_subtotal || cc_name || cc_processing_code).present? && (cash_subtotal || cash_name).present?
      errors.clear
      errors.add(:Hey_Jerk!, 'Very sneaky...Only one payment type is allowed')
    end
  end

  def has_payment_type
    unless (cash_subtotal || cash_name).present? \
    || (check_subtotal || check_name || check_number || check_routing).present? \
    || (cc_subtotal || cc_name || cc_processing_code).present?
      errors.add(:payment_information, 'cannot be blank')
    end
  end

  def cash_fields_valid
    if (cash_subtotal || cash_name).present?
      errors.add(:payment_amount, "cannot be greater than the balance due - $#{invoice.balance_due}") if cash_subtotal.nil?
      errors.add(:cash_amount, 'must be greater than $0') unless cash_subtotal.nil? || cash_subtotal.to_i > 0
      errors.add(:name, 'cannot be blank') unless cash_name.present?
    end
  end

  def check_fields_valid
    if (check_subtotal || check_name || check_number || check_routing).present?
      errors.add(:payment_amount, "cannot be greater than the balance due - $#{invoice.balance_due}") if check_subtotal.nil?
      errors.add(:check_amount, 'must be greater than $0') unless check_subtotal.nil? || check_subtotal.to_i > 0
      errors.add(:name, 'cannont be blank') unless check_name
      errors.add(:check_number, 'cannont be blank') unless check_number
      errors.add(:routing_number, 'cannont be blank') unless check_routing
    end
  end

  def credit_fields_valid
    if (cc_subtotal || cc_name || cc_processing_code).present?
      errors.add(:payment_amount, "cannot be greater than the balance due - $#{invoice.balance_due}") if cc_subtotal.nil?
      errors.add(:credit_amount, 'must be greater than $0') unless cc_subtotal.nil? || cc_subtotal.to_i > 0
      errors.add(:name, 'cannot be blank') unless cc_name
      errors.add(:processing_code, 'cannot be blank') unless cc_processing_code
    end
  end

  def payment_less_than_amount_due
    if (cc_subtotal || check_subtotal || cash_subtotal).to_i > invoice.balance_due
      errors.add(:payment_amount, 'cannot be greater than the amount due.')
    end
  end

end
