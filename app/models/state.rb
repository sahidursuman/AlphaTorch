class State < ActiveRecord::Base
  belongs_to :country
  has_many :customer_addresses
  has_many :properties
end
