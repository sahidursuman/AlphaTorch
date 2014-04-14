class Invoice < ActiveRecord::Base
  belongs_to :status, primary_key: 'status_code', foreign_key: 'status_code'
  after_initialize :set_default_status
  has_many :payment_details, dependent: :destroy
  has_many :events
  has_many :workorders, through: :events

  scope :past_due, ->{where("due_date < '#{Date.today}' AND (status_code != '#{Status.get_code('Paid')}' OR status_code != '#{Status.get_code('Processing')}')")}
  scope :orphaned, ->{
    select { |i| i.empty? }
  }
  scope :not_orphaned, -> {select { |i| !i.empty? }}

  def invoice_amount_dollars
    if self.invoice_amount
      if self.invoice_amount.is_a?(Integer)
        return self.invoice_amount / 100.00
      elsif self.invoice_amount.is_a?(String)
        return ''
      end
    else
      return nil
    end
  end

  def invoice_amount_dollars=(amount)
    self.invoice_amount = (Float(amount) * 100).to_i
  rescue
    self.invoice_amount = amount
  end

  def set_default_status
    if past_due?
      unless self.status_code == Status.get_code('Past Due')
        set_past_due
      end
    elsif created?
      unless self.status_code == Status.get_code('Created')
        set_created
      end
    elsif paid?
      unless self.status_code == Status.get_code('Paid')
        set_paid
      end
    end
  end

  def past_due?
    self.due_date < Date.today && self.balance_due > 0
  end

  def created?
    !self.past_due? && !paid?
  end

  def paid?
    self.balance_due == 0 && self.events.present?
  end

  def update_total
    p 'Updating Invoice Total'
    self.invoice_amount_dollars = events.map {|e| e.event_services.map(&:cost_dollars).sum}.sum
    self.save
  end

  def finalize
    self.status_code = Status.get_code('Final')
    self.events.each(&:lock)
    self.save!
  end

  def destroy
    events.each(&:remove_from_invoice)
    super
  end

  def line_items
    event_services = events.map(&:event_services).flatten
    event_services.map do |es|
      {service: es.service.name, event_date:es.event.start, cost:es.cost}
    end
  end

  def payment_total
    payment_details.map do |payment|
      [payment.cash_subtotal_dollars.to_f, payment.check_subtotal_dollars.to_f, payment.cc_subtotal_dollars.to_f].sum
    end.flatten.sum
  end

  def make_payment(options={})
    payment_date = options.delete(:payment_date) || Date.today
    payment_type = options.delete(:payment_type)
    payment_amount = options.delete(:payment_amount)

    payment = PaymentDetail.new(invoice_id: id, payment_date: payment_date)
    case payment_type.upcase
      when 'CASH'
        payment.cash_subtotal_dollars = payment_amount
      when 'CREDIT'
        payment.cc_processing_code = options.delete(:processing_code)
        payment.cc_subtotal_dollars = payment_amount
      when 'CHECK'
        payment.check_name = options.delete(:check_name)
        payment.check_number = options.delete(:check_number)
        payment.check_routing = options.delete(:check_routing)
        payment.check_subtotal_dollars = payment_amount
    end

    payment.save

  end

  def unpaid?
    status_code != Status.get_code('Paid')
  end

  def balance_due
    invoice_amount_dollars - payment_total
  end

  def update_status
    if balance_due == 0 && events.present?
      set_paid
    elsif balance_due > 0 && due_date < Date.today
      set_past_due
    else
      set_created
    end

  end

  def workorder
    workorders.uniq.first
  end

  def empty?
    events.empty?
  end

  def self.destroy_orphaned
    orphaned.each(&:destroy)
  end


  private

  def set_paid
    self.status_code = Status.get_code('Paid')
    self.save
  end

  def set_created
    self.status_code = Status.get_code('Created')
    self.save
  end

  def set_past_due
    self.status_code = Status.get_code('Past Due')
    self.save
  end

end
