class CustomerProperty < ActiveRecord::Base
  belongs_to :customer
  belongs_to :property
  has_many :workorders
end
