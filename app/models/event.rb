class Event < ActiveRecord::Base
  after_save :update_invoice
  after_destroy :update_invoice
  after_update :update_event_services
  require 'date_helper'
  include DateHelper
  require 'model_locking'
  include ModelLocking

  belongs_to :status, primary_key: 'status_code', foreign_key: 'status_code'
  belongs_to :workorder
  has_many :event_services, dependent: :destroy
  has_many :services, through: :event_services
  accepts_nested_attributes_for :event_services, allow_destroy: true
  belongs_to :invoice

  scope :invoiced,             ->{where.not(invoice_id: nil)}
  scope :not_invoiced,         ->{where(invoice_id: nil)}
  scope :future_events,        ->{where("start > '#{DateTime.now}'")}
  scope :billing_cycle,        ->{where("start BETWEEN '#{DateHelper.first_day_of_month}' AND '#{DateHelper.last_day_of_month}'")}
  scope :before_billing_cycle, ->{where("start < '#{DateHelper.first_day_of_month}'")}
  scope :past,                 ->{where("start <= '#{DateTime.now}'")}

  validates_uniqueness_of :name, scope: :start
  validates_associated :event_services

  STATUS_COLORS = {
      Status.get_code('Not Invoiced') => {backgroundColor: 'gray',  borderColor: 'gray',  textColor: 'white'},
      Status.get_code('Invoiced')     => {backgroundColor: 'green', borderColor: 'green', textColor: 'white'},
      Status.get_code('Locked')       => {backgroundColor: 'red',   borderColor: 'red',   textColor: 'white'}
  }

  def unlock(force=false)
    if !self.invoice || force
      self.status_code = Status.get_code('Not Invoiced')
      self.save ? true : false
    elsif self.invoice
      self.status_code = Status.get_code('Invoiced')
      self.save ? true : false
    else
      false
    end
  end

  def remove_from_invoice
    i = self.invoice
    self.invoice = nil
    if self.save
      if self.unlock
        i.update_total
        if i.events.empty?
          i.destroy
        end
        true
      end
    else
      false
    end
  end

  def add_to_invoice(id)
    self.invoice = Invoice.find(id)
    if self.save && self.make_invoiced
      self.invoice.update_total
      true
    else
      false
    end
  end

  def make_invoiced
    self.status_code = Status.get_code('Invoiced')
    self.save ? true : false
  end

  def invoiced?
    self.invoice_id != nil
  end

  def update_attributes(params)
    if params[:all_day] == true
      params[:start] = params[:start].to_datetime.midnight
    end
    super(params)
  end

  def self.invoice_destroyed(invoice_id)
    if Invoice.where(id: invoice_id).empty?
      events = where(invoice_id: invoice_id)
      events.update_all(invoice_id: nil, status_code: Status.get_code('Not Invoiced'))
      true
    else
      false
    end

  end

  def self.to_calendar(from_date, to_date)
    results  = Event.where("(start >= '#{from_date}' AND start <= '#{to_date}')")
    results.map do |event|
      services = event.event_services.map {|es| es.service.name}.join('<br/>')
      {id: event.id,
       workorder_id: event.workorder_id,
       title: event.name,
       start: event.start,
       end: event.end,
       allDay: event.all_day,
       editable: (!event.locked? && !event.invoiced?),
       services: services}.merge(STATUS_COLORS[event.status_code])
    end.flatten
  end

  private

  def update_invoice
    if self.invoice
      self.invoice.update_total
    end
  end

  def update_event_services
    self.event_services.each do |event_service|
      workorder_service = event_service.workorder_service
      if workorder_service.single_occurrence?
        workorder_service.single_occurrence_date = self.start.to_date
        workorder_service.save
      end
    end
  end
end
