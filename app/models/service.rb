class Service < ActiveRecord::Base
  has_many :workorder_services
  has_many :workorders, through: :workorder_services
end
