class CustomerAddress < ActiveRecord::Base
  belongs_to :state
  belongs_to :customer
end
