class Status < ActiveRecord::Base
  has_many :invoices
  has_many :events
  has_many :workorders
  has_many :customers

  def self.statuses
    statuses = {}
    all.each do |status|
      statuses[status.status_code] = status.status
    end
    statuses
  end

  def self.get_status(code)
    statuses[code] rescue nil
  end

  def self.get_code(status)
    statuses.key(status)
  end


end
