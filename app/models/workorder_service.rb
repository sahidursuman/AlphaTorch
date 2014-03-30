class WorkorderService < ActiveRecord::Base
  after_create :create_events
  after_update :update_events
  include IceCube
  require 'date_helper'
  include DateHelper

  belongs_to :service
  belongs_to :workorder
  has_many :event_services

  serialize :schedule, Hash

  #validates_presence_of :schedule, unless: ->(ws) {ws.single_occurrence_date.present?}
  validates_presence_of :cost
  validates_numericality_of :cost

  def create_events
    occurrence_dates = self.recurring? ?
       get_requested_occurrences(false) :
       [self.single_occurrence_date.to_date + 5.hours]

    process_occurrence_dates(occurrence_dates)
  end

  def update_events
    occurrence_dates = self.recurring? ?
        get_requested_occurrences(true) :
        [self.single_occurrence_date.to_date + 5.hours]

    process_occurrence_dates(occurrence_dates)
    destroy_invalid_events
  end

  def process_occurrence_dates(occurrence_dates)
    occurrence_dates.each do |event_date|
      event = Event.where("workorder_id = #{self.workorder_id} AND start::date = '#{event_date}'").first_or_initialize
      if event.new_record?
        event = create_event(event_date)
      end
      create_event_service(event)
    end
  end

  def get_requested_occurrences(future_only)
    if future_only
      get_remaining_occurrence_dates
    else
      get_all_occurrence_dates
    end
  end

  def get_all_occurrence_dates
    converted_schedule.all_occurrences.map(&:to_date)
  end

  def get_remaining_occurrence_dates
    dates = converted_schedule.remaining_occurrences.map(&:to_date)
    if get_all_occurrence_dates.include? Date.today
      dates << Date.today unless dates.include? Date.today
    end
    dates
  end

  def create_event(event_date)
    event = Event.new
    event.workorder_id = self.workorder_id
    event.start = event_date
    event.end = nil
    event.all_day = true
    event.name = self.workorder.name
    event.invoice_id = nil
    event.status_code = Status.get_code('Not Invoiced')
    Event.create!(event.attributes)
  end

  def create_event_service(event)
    #because this is a single occurrence, it can by definition only belong
    #to one event. this will delete all associated event services, unless
    #the event service belongs to the current associated event. if an event
    #gets destroyed, then a flag is set to ensure that a new event service is
    #created in its place.
    if self.single_occurrence?
      should_create_event_service = self.event_services.present? ? false : true
      self.event_services.each do |event_service|
        unless event_service.event == event
          evnt = event_service.event
          p 'EVENT SERVICE MOVED...DESTROYING DUPLICATE'
          event_service.destroy
          evnt.reload
          p 'EVENT RELOADED'
          if evnt.event_services.empty?
            'NO SERVICES...DESTROYING EVENT'
            evnt.destroy
          else
            p 'EVENT STILL HAS SERVICES'
          end
          should_create_event_service = true
        end
      end
    else
      should_create_event_service = true
    end

    if should_create_event_service
      event_service = EventService.new
      event_service.workorder_service_id = self.id
      event_service.event_id = event.id
      event_service.service_id = self.service.id
      event_service.cost = self.cost
      EventService.where(event_service.attributes).first_or_create!
    end
  end

  def single_occurrence?
    single_occurrence_date.present?
  end

  def recurring?
    schedule.present?
  end

  def future_events
    Event.future_events.where(workorder_id:self.workorder_id)
  end

  def destroy_invalid_events
    remaining_dates = future_events.map(&:start).map(&:to_date)
    valid_dates = get_remaining_occurrence_dates
    to_destroy = remaining_dates - valid_dates
    to_destroy.each do |event_date|
      event = Event.where("workorder_id = #{self.workorder_id} AND start::date = '#{event_date}'").first
      if event.present?
        should_destroy_event = true
        event.event_services.each do |event_service|
          if event_service.workorder_service_id == self.id
            event_service.destroy
          else
            should_destroy_event = false
          end
        end

        if should_destroy_event
          event.destroy
        end
      end
    end
  end

  def schedule=(new_schedule)
    if new_schedule != 'null' && new_schedule.present?
      write_attribute(:schedule, RecurringSelect.dirty_hash_to_rule(new_schedule).to_hash)
    else
      nil
    end
  end

  def converted_schedule
    s = read_attribute(:schedule)
    unless s.empty?
      cycle_start = billing_cycle_start
      cycle_end   = billing_cycle_end
      the_schedule = Schedule.new(cycle_start)
      the_schedule.add_recurrence_rule(RecurringSelect.dirty_hash_to_rule(s).until(cycle_end))
      the_schedule
    end
  end

  def billing_cycle_start
    #check to see if there are any invoices
    #if not then the workorder is starting in the middle of a cycle
    #if so then all recurring workorders will start the billing cycle on the first
    workorder.invoices.present? ? DateHelper.first_day_of_month : workorder.start_date
  end

  def billing_cycle_end
    #if the billing cycle starts in a future month, then set the end date to the last day of the starting month
    DateHelper.last_day_of_month(billing_cycle_start.year, billing_cycle_start.month)
  end

end
