class EventService < ActiveRecord::Base
  after_commit :update_invoice
  after_commit :destroy_workorder_service, on: :destroy
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

  def destroy_workorder_service
    if self.workorder_service && self.workorder_service.single_occurrence?
      self.workorder_service.destroy
    end
  end
end
