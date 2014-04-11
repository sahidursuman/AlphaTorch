class CustomerProperty < ActiveRecord::Base
  after_create :create_billing_address
  belongs_to :customer
  belongs_to :property
  has_many :workorders, dependent: :destroy
  require 'model_locking'
  include ModelLocking

  belongs_to :status, primary_key: 'status_code', foreign_key: 'status_code'

  def change_status(status)
    case status
      when 'Active'
        remove_hold
      when 'Locked'
        set_on_hold
    end
  end

  def set_on_hold
    unless status_code == Status.get_code('Locked')
      self.status_code = Status.get_code('Locked')
      self.save
      workorders.each{|w| w.change_status('Locked') unless w.closed?}
    end
  end

  def remove_hold
    unless status_code == Status.get_code('Active')
      self.status_code = Status.get_code('Active')
      self.save
      workorders.each{|w| w.set_default_status}
    end
  end

  def create_billing_address
    if self.owner == true && !self.customer.customer_address
      attr = self.property.attributes.except('id', 'map_data', 'created_at', 'updated_at')
      attr.merge!({customer_id:self.customer_id})
      CustomerAddress.create(attr)
    end
  end

end
