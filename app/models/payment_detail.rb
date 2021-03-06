class PaymentDetail < ActiveRecord::Base
  include ActionView::Helpers::UrlHelper
  include MoneyRails::ActionViewExtension
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
  validate :payment_less_than_amount_due, on: :create
  validate :payment_less_than_amount_due_update, on: :update
  validate :invoice_status_not_paid, on: :create

  attr_accessor :old_payment_amount, :method

  CC_TYPES = %w(Visa Mastercard American\ Express Discover)

  def cash_subtotal_dollars
    if self.cash_subtotal
      if self.cash_subtotal.is_a?(Integer)
        return self.cash_subtotal / 100.00
      elsif self.cash_subtotal.is_a?(String)
        return ''
      end
    else
      return nil
    end
  end

  def cash_subtotal_dollars=(amount)
    self.cash_subtotal = (Float(amount) * 100.00).ceil
  rescue
    self.cash_subtotal = amount
  end

  def check_subtotal_dollars
    if self.check_subtotal
      if self.check_subtotal.is_a?(Integer)
        return self.check_subtotal / 100.00
      elsif self.check_subtotal.is_a?(String)
        return ''
      end
    else
      return nil
    end
  end

  def check_subtotal_dollars=(amount)
    self.check_subtotal = (Float(amount) * 100).to_i
  rescue
    self.check_subtotal = amount
  end

  def cc_subtotal_dollars
    if self.cc_subtotal
      if self.cc_subtotal.is_a?(Integer)
        return self.cc_subtotal / 100.00
      elsif self.cc_subtotal.is_a?(String)
        return ''
      end
    else
      return nil
    end
  end

  def cc_subtotal_dollars=(amount)
    self.cc_subtotal = (Float(amount) * 100).to_i
  rescue
    self.cc_subtotal = amount
  end

  def amount
    cash_subtotal_dollars.to_f + check_subtotal_dollars.to_f + cc_subtotal_dollars.to_f
  end

  def payment_method
    if cash_subtotal
      'Cash'
    elsif check_subtotal
      'Check'
    elsif cc_subtotal
      'Credit'
    else
      nil
    end
  end

  def check_routing
    cr = read_attribute(:check_routing)
    if cr.blank?
      cr = nil
    end
    cr
  end

  def cc_processing_code
    ccp = read_attribute(:cc_processing_code)
    if ccp.blank?
      ccp = nil
    end
    ccp
  end

  def name
    if cash_subtotal
      cash_name
    elsif check_subtotal
      check_name
    elsif cc_subtotal
      cc_name
    else
      nil
    end
  end

  def to_data_table_row
    [self.payment_date.strftime('%m/%d/%Y'), invoice_link, self.name, humanized_money_with_symbol(self.amount), self.payment_method, self.check_number||'-', self.check_routing||'-', self.cc_processing_code||'-', edit_link, destroy_link]
  end

  def edit_link
    link_to 'Edit',
    Rails.application.routes.url_helpers.edit_payment_detail_path(id:self.id, invoice_id:self.invoice_id),
    remote:true,
    id:'edit_payment_details_link'
  end

  def destroy_link
    link_to 'Destroy',
    Rails.application.routes.url_helpers.payment_detail_path(id:self.id),
    remote:true,
    method: :delete,
    id:'destroy_payment_details_link',
    data:{confirm:'Are you sure?'}
  end

  def invoice_link
    link_to invoice_id,
    Rails.application.routes.url_helpers.invoice_path(id:self.invoice_id, workorder_id:self.invoice.workorder.id)
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
      errors.add(:payment_amount, 'cannot be blank') if cash_subtotal.nil?
      errors.add(:cash_amount, 'must be greater than $0') unless cash_subtotal.nil? || cash_subtotal.to_i > 0
      errors.add(:name, 'cannot be blank') unless cash_name.present?
    end
  end

  def check_fields_valid
    if (check_subtotal || check_name || check_number || check_routing).present?
      errors.add(:payment_amount, 'cannot be blank') if check_subtotal.nil?
      errors.add(:check_amount, 'must be greater than $0') unless check_subtotal.nil? || check_subtotal.to_i > 0
      errors.add(:name, 'cannont be blank') unless check_name
      errors.add(:check_number, 'cannont be blank') unless check_number
      errors.add(:routing_number, 'cannont be blank') unless check_routing
    end
  end

  def credit_fields_valid
    if (cc_subtotal || cc_name || cc_processing_code).present?
      errors.add(:payment_amount, 'cannot be blank') if cc_subtotal.nil?
      errors.add(:credit_amount, 'must be greater than $0') unless cc_subtotal.nil? || cc_subtotal.to_i > 0
      errors.add(:name, 'cannot be blank') unless cc_name
      errors.add(:processing_code, 'cannot be blank') unless cc_processing_code
    end
  end

  def payment_less_than_amount_due
    if (cc_subtotal_dollars || check_subtotal_dollars || cash_subtotal_dollars) > invoice.balance_due
      errors.add(:payment_amount, "cannot be greater than the amount due - $#{invoice.balance_due}")
    end
  end

  def payment_less_than_amount_due_update
    balance = invoice.balance_due + old_payment_amount.to_f
    if (cc_subtotal_dollars || check_subtotal_dollars || cash_subtotal_dollars) > balance
      errors.add(:payment_amount, "cannot be greater than the amount due - #{humanized_money_with_symbol(balance)}")
    end
  end

  def invoice_status_not_paid
    unless invoice.unpaid?
      errors.clear
      errors.add(:invoice, 'has already been paid. Payments are no longer authorized')
    end
  end

  private

  def update_invoice
    self.invoice.reload
    self.invoice.update_status
  end

end
