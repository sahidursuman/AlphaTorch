class EventService < ActiveRecord::Base
  after_save :update_invoice
  after_destroy :update_invoice
  belongs_to :service
  belongs_to :event
  belongs_to :invoice
  belongs_to :workorder_service

  validates_presence_of :cost
  validates_numericality_of :cost

  private

  def update_invoice
    if self.event.invoice
      p 'Updating invoice due to event service changing'
      self.event.invoice.update_total
    end
  end
end
