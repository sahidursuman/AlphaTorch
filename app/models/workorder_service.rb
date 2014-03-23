class WorkorderService < ActiveRecord::Base
  after_commit {|ws| ws.workorder.update_events}
  include IceCube
  require 'date_helper'
  include DateHelper

  belongs_to :service
  belongs_to :workorder

  serialize :schedule, Hash

  validates_presence_of :schedule
  validates_presence_of :cost
  validates_numericality_of :cost

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
    (workorder.invoices.nil? || workorder.invoices.empty?) ? workorder.start_date : DateHelper.first_day_of_month
  end

  def billing_cycle_end
    #if the billing cycle starts in a future month, then set the end date to the last day of the starting month
    DateHelper.last_day_of_month(billing_cycle_start.year, billing_cycle_start.month)
  end

end
