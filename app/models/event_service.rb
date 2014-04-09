class EventService < ActiveRecord::Base
  after_commit :update_invoice
  after_commit :destroy_workorder_service, on: :destroy
  belongs_to :service
  belongs_to :event
  belongs_to :invoice
  belongs_to :workorder_service

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
