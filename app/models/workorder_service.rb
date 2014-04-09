class WorkorderService < ActiveRecord::Base
  after_create :create_events
  after_update :update_events
  after_destroy :delete_event_services
  include IceCube
  require 'date_helper'
  include DateHelper

  belongs_to :service
  belongs_to :workorder
  has_many :event_services

  serialize :schedule, Hash

  validates_presence_of :cost
  validates_numericality_of :cost

  def cost_dollars
    if self.cost
      if self.cost.is_a?(Integer)
        return self.cost / 100.00
      elsif self.cost.is_a?(String)
        return ''
      end
    else
      return nil
    end
  end

  def cost_dollars=(amount)
    self.cost = (Float(amount) * 100.00).ceil
  rescue
    self.cost = amount
  end

  def create_events
    occurrence_dates = self.recurring? ?
       get_requested_occurrences(false) :
       [self.single_occurrence_date.to_datetime.midnight]

    process_occurrence_dates(occurrence_dates)
  end

  def update_events
    occurrence_dates = self.recurring? ?
        get_requested_occurrences(true) :
        [self.single_occurrence_date.to_datetime.midnight]

    process_occurrence_dates(occurrence_dates)
    destroy_invalid_events unless self.single_occurrence?
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
    if converted_schedule.present?
      dates = converted_schedule.remaining_occurrences.map(&:to_date)
      if get_all_occurrence_dates.include? Date.today
        dates << Date.today unless dates.include? Date.today
      end
      dates
    else
      []
    end
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
    #the event service belongs to the current associated event.
    if self.single_occurrence?
      self.event_services.each do |event_service|
        unless event_service.event == event
          evnt = event_service.event
          event_service.destroy
          evnt.reload
          if evnt.event_services.empty?
            evnt.destroy
          end
        end
      end
    end

    event_service = EventService.new
    event_service.workorder_service_id = self.id
    event_service.event_id = event.id
    event_service.service_id = self.service_id
    event_service.cost_dollars = self.cost_dollars
    p "EVENT ID = #{event.id}"
    p "CHECKING IF EVENT SERVICE FOR #{service.name} EXISTS IN EVENT ALREADY"
    if EventService.where(event_id:event.id, service_id:self.service_id).empty?
      unless event_service.workorder_service_id.nil? || event.invoiced?
        p "EVENT SERVICE NOT FOUND FOR EVENT #{event.id} - #{service.name}"
        EventService.create!(event_service.attributes)
      end
    else
      p "EVENT SERVICE FOUND FOR EVENT #{event.id} - #{service.name}"
    end
    p '*******************************'

    #if a repeating workorder service's service is changed, then a extra event service
    #for the previous service will still exist. this will go throught the event services
    #and check for service ids that do not match the service id of the associated workorder
    #service
    event.event_services.each do |event_service|
      sid = event_service.service_id
      ws_sid = event_service.workorder_service.service.id
      if ws_sid != sid
        event_service.destroy
      end
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
    p "REMAINING DATES = #{remaining_dates.sort}"
    valid_dates = get_remaining_occurrence_dates
    p "VALID DATES = #{valid_dates.sort}"
    to_destroy = remaining_dates - valid_dates
    p "TO DESTROY = #{to_destroy}"
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

  def delete_event_services
    if self.event_services
      if self.single_occurrence?
        self.event_services.each(&:destroy)
      else
        self.event_services.each do |event_service|
          if event_service.event.start > DateTime.now
            if event_service.event.event_services.count == 0
              event_service.event.destroy
            else
              event_service.destroy
            end
          end
        end
      end
    end
  end
end
