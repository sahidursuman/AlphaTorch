class Customer < ActiveRecord::Base
  include ActionView::Helpers::UrlHelper
  include MoneyRails::ActionViewExtension

  belongs_to :status, primary_key: 'status_code', foreign_key: 'status_code'
  has_many :customer_addresses
  has_many :customer_properties
  has_many :properties, through: :customer_properties

  def to_data_table_row
    [html_name, first_phone, second_phone, email_address, html_addresses, balance_due]
  end

  def first_phone
    self.primary_phone
  end

  def second_phone
    self.secondary_phone
  end

  def email_address
    self.email
  end

  def balance_due
    
  end

  def all_customer_properties
    customer_properties.where(owner: true).all
  end

  def name
    mi = (self.middle_initial.nil? || self.middle_initial.empty?) ? '' : self.middle_initial + '. '
    self.first_name + ' ' + mi + self.last_name
  end

  def html_name
    link_to name.html_safe, Rails.application.routes.url_helpers.customer_path(self)
  end

  def workorders
    customer_properties.map(&:workorders)
  end

  def html_addresses
    customer_properties.where(owner: true).map do |cp|
        cp.property.html_full_address
    end.join('<br/><br/>'.html_safe)
  end

end
