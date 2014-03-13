class Invoice < ActiveRecord::Base
  belongs_to :status, primary_key: 'status_code', foreign_key: 'status_code'
  has_many :payment_details
  has_many :events
  has_one :workorder, through: :events

  scope :past_due, ->{where("due_date < '#{Date.today}' AND (status_code != '#{Status.get_code('Paid')}' OR status_code != '#{Status.get_code('Processing')}')")}

  def update_total
    'Updating Invoice Total'
    self.invoice_amount = events.map {|e| e.event_services.map(&:cost).sum}.sum
    self.save!
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
      [payment.cash_subtotal.to_i, payment.check_subtotal.to_i, payment.cc_subtotal.to_i].sum
    end.flatten.sum
  end

  def make_payment(options={})
    payment_date = options.delete(:payment_date) || Date.today
    payment_type = options.delete(:payment_type)
    payment_amount = options.delete(:payment_amount)

    payment = PaymentDetail.new(invoice_id: id, payment_date: payment_date)
    case payment_type.upcase
      when 'CASH'
        payment.cash_subtotal = payment_amount
      when 'CREDIT'
        payment.cc_processing_code = options.delete(:processing_code)
        payment.cc_subtotal = payment_amount
      when 'CHECK'
        payment.check_name = options.delete(:check_name)
        payment.check_number = options.delete(:check_number)
        payment.check_routing = options.delete(:check_routing)
        payment.check_subtotal = payment_amount
    end

    payment.save if payment.valid? else false

  end

  def unpaid?
    invoice_amount > payment_total
  end

  def balance_due
    invoice_amount - payment_total
  end

end
