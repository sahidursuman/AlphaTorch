class Customer < ActiveRecord::Base
  belongs_to :status, primary_key: 'status_code', foreign_key: 'status_code'
  has_many :customer_addresses
  has_many :customer_properties
  has_many :properties, through: :customer_properties

  def name
    mi = (self.middle_initial.nil? || self.middle_initial.empty?) ? '' : self.middle_initial + '. '
    self.first_name + ' ' + mi + self.last_name
  end

  def workorders
    customer_properties.map(&:workorders)
  end
end
