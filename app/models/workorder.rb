class Workorder < ActiveRecord::Base
  after_save :update_events
  require 'model_locking'
  include ModelLocking
  include ActionView::Helpers::UrlHelper

  belongs_to :status, primary_key: 'status_code', foreign_key: 'status_code'
  has_many :events, dependent: :destroy
  has_many :invoices, through: :events
  has_many :workorder_services, dependent: :destroy
  has_many :services, through: :workorder_services
  accepts_nested_attributes_for :workorder_services, allow_destroy: true
  belongs_to :customer_property

  validates_associated :workorder_services
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :start_date

  def unlock
    self.status_code = Status.get_code('Not Invoiced')
    self.save ? true : false
  end

  def status_name
    Status.get_status(status_code)
  end

  def create_events(future_only=false)
    unique_dates = []

    workorder_services.each do |ws|
      all = ws.converted_schedule.all_occurrences
      future = ws.converted_schedule.remaining_occurrences
      occurrences = future_only ? future : all

      occurrences.each do |date|
        unless unique_dates.include? date
          unique_dates.push date
        end
      end
    end

    unique_dates.each do |date|
      event = Event.new
      event.workorder = self
      event.name = name
      event.start = date
      event.end = nil
      event.all_day = true
      event.save!

      workorder_services.each do |ws|
        if ws.converted_schedule.all_occurrences.include? date
          event_service = EventService.new
          event_service.event = event
          event_service.service = ws.service
          event_service.cost = ws.cost
          event_service.save!
        end
      end

    end

    true
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

  def has_uninvoiced_events_in_past
    Event.not_invoiced.before_billing_cycle.where(workorder_id: self.id).count > 0
  end

  def generate_invoice(invoice_events=valid_uninvoiced_billing_cycle_events)
    invoice = Invoice.new
    invoice_events.each do |event|
      event.invoice = invoice
      if event.lock && event.save
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
    [html_name, status.status]
  end

  def html_name
    link_to name, Rails.application.routes.url_helpers.workorder_path(self)
  end

  def self.generate_all_invoices
    p "#{Time.now} - Generating invoices for all workorders..."
    all.each(&:generate_invoice)
    p "#{Time.now} - Complete!"
  end

  def self.create_all_events
    p "#{Time.now} - Generating scheduled events for billing cycle..."
    ModelLocking.not_locked(self).each(&:create_events)
    p "#{Time.now} - Complete!"
  end

end
