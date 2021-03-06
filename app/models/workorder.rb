class Workorder < ActiveRecord::Base
  after_create :set_default_status
  after_initialize :set_default_status
  after_commit :update_workorder_services, :update_events, on: :update
  require 'model_locking'
  include ModelLocking
  include ActionView::Helpers::UrlHelper
  include MoneyRails::ActionViewExtension

  belongs_to :status, primary_key: 'status_code', foreign_key: 'status_code'
  has_many :events, dependent: :destroy
  has_many :invoices, through: :events
  has_many :workorder_services, dependent: :destroy
  has_many :services, through: :workorder_services
  accepts_nested_attributes_for :workorder_services, allow_destroy: true
  belongs_to :customer_property

  scope :created, ->{where(status_code: Status.get_code('Created'))}
  scope :active, ->{where(status_code: Status.get_code('Active'))}
  scope :on_hold, ->{where(status_code: Status.get_code('Locked'))}
  scope :closed, ->{where(status_code: Status.get_code('Closed'))}
  scope :current, ->{where("status_code != #{Status.get_code('Closed')}")}

  #validates_associated :workorder_services
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :start_date

  def set_default_status
    unless self.new_record? || self.closed?
      if !customer_property.locked?
          self.start_date <= Date.today ? self.change_status('Active') : self.change_status('Created')
      end
    end
  end

  def closed?
    self.status_code == Status.get_code('Closed')
  end

  def future_events
    events.future_events
  end

  def future_uninvoiced_events
    future_events.not_invoiced
  end

  def destroy_future_uninvoiced_events
    #event.destroy will update the invoice for us
    future_uninvoiced_events.each(&:destroy)
  end

  def update_events
    destroy_future_uninvoiced_events
    create_events(true)
  end

  def billing_cycle_events
    events.billing_cycle
  end

  def uninvoiced_events
    events.not_invoiced
  end

  def uninvoiced_billing_cycle_events
    billing_cycle_events & uninvoiced_events
  end

  def valid_uninvoiced_billing_cycle_events
    Event.billing_cycle.not_invoiced.past.where(workorder_id: self.id)
  end

  def has_valid_uninvoiced_billing_cycle_events
    valid_uninvoiced_billing_cycle_events.count > 0
  end

  def has_uninvoiced_events_in_past
    Event.not_invoiced.before_billing_cycle.where(workorder_id: self.id).count > 0
  end

  def close
    self.generate_invoice(uninvoiced_events.past)
    self.status_code = Status.get_code('Closed')
    self.save
    self.destroy_future_uninvoiced_events
  end

  def generate_invoice(invoice_events=valid_uninvoiced_billing_cycle_events)
    invoice = Invoice.new
    invoice.id = Time.now.to_i
    invoice_events.each do |event|
      event.invoice_id = invoice.id
      if event.make_invoiced && event.save
        invoice.invoice_amount += event.event_services.map(&:cost).sum
      end
    end

    if invoice_events.any?
      invoice.invoice_date = Date.today
      invoice.due_date = Date.today + 1.month
      invoice.save if invoice.valid?
    end
  end

  def invoices
    if invoice_ids.uniq.length > 0
      Invoice.where("id IN (#{invoice_ids.uniq.join(', ')})")
    end
  end

  def property
    customer_property.try(:property)
  end

  def to_data_table_row
    [name, customer_property.property.html_full_address, customer_property.customer.html_name, next_event || 'N/A', status.status, humanized_money_with_symbol(balance_due)]
  end

  def html_name
    link_to name, Rails.application.routes.url_helpers.workorder_path(self)
  end

  def next_event
    event = future_events.first
    if event
      event.event_services.map(&:service).map(&:name).join(', ') << event.start.strftime(' on %Y-%m-%d')
    end
  end

  def balance_due
    if invoices
      invoices.map(&:balance_due).sum
    else
      0
    end
  end

  def change_status(status)
    unless status_code == Status.get_code(status)
      self.status_code = Status.get_code(status)
      self.save
      case status
        when 'Locked'
          events.not_invoiced.map(&:lock)
        when 'Active', 'Created'
          events.not_invoiced.map(&:unlock)
      end
    end
  end

  def self.generate_all_invoices
    p "#{Time.now} - Generating invoices for all workorders..."
    all.each(&:generate_invoice)
    p "#{Time.now} - Complete!"
  end

  def self.create_all_events
    p "#{Time.now} - Generating scheduled events for billing cycle..."
    ModelLocking.not_locked(self).map(&:workorder_services).each(&:create_events)
    p "#{Time.now} - Complete!"
  end

  private

  def update_workorder_services
    self.workorder_services.each(&:update_events)
  end

  def update_events
    self.events.each {|e| e.name = self.name; e.save}
  end
end
