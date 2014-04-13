class Property < ActiveRecord::Base
  before_save :get_map_coordinates
  before_update :update_billing_address
  after_destroy :remove_customer_address
  require 'net/http'
  include ActionView::Helpers::UrlHelper
  include MoneyRails::ActionViewExtension
  belongs_to :state
  has_many :customer_properties, dependent: :destroy
  has_many :customers, through: :customer_properties

  def to_data_table_row
    [html_full_address, html_owner, html_services, humanized_money_with_symbol(balance_due)]
  end

  def html_full_address
    link_to "#{street_address_1 +
     '<br/>' +
     (street_address_2.to_s=='' ? '' : street_address_2.to_s + '<br/>') +
     city + ', ' + state.short_name + ' ' + postal_code}
    ".html_safe, Rails.application.routes.url_helpers.property_path(self)
  end

  def full_address
    street_address_1.gsub(' ', '+') + '+' +
    (street_address_2.to_s == '' ? '' : street_address_2.to_s.gsub(' ', '+')+ '+') +
    city.gsub(' ', '+') + '+' +
    state.short_name + '+' +
    postal_code
  end

  def current_customer_property
    customer_properties.where(owner: true).first
  end

  def current_owner_name
    current_customer_property ? current_customer_property.customer.name : 'No Owner'
  end

  def html_owner
    if current_owner_name != 'No Owner'
      link_to current_owner_name, Rails.application.routes.url_helpers.customer_path(current_customer_property.customer)
    else
      current_owner_name
    end
  end

  def workorders
    current_customer_property ? current_customer_property.try(:workorders) : []
  end

  def has_active_workorders?
    workorders.empty? ? false : workorders.active.count > 0
  end

  def html_services
    unless services.nil? || services.try(:empty?)
      services.uniq.map(&:name).join('<br/>').html_safe
    else
      'No Services'
    end
  end

  def services
    if workorders
      workorders.map(&:workorder_services).flatten.map(&:service).flatten
    end
  end

  def workorder_services
    if workorders
      workorders.map(&:workorder_services).compact.flatten
    end
  end

  def invoices
    workorders.map(&:invoices).compact.flatten if workorders
  end

  def unpaid_invoices
    invoices.compact.map{|invoice| invoice if invoice.unpaid?} if invoices
  end

  def balance_due
    unless unpaid_invoices.nil? || unpaid_invoices.compact.empty?
      unpaid_invoices.compact.map(&:balance_due).sum
    else
      0
    end
  end

  def links
    "#{link_to('View', Rails.application.routes.url_helpers.property_path(self), class: 'btn btn-default btn-sm')}".html_safe
  end

  def self.generate_map_data
    select(:map_data).map do |property|
      JSON::parse property.map_data
    end
  end

  def get_map_coordinates
    lat_long_arr = []
    parsed_url = URI.parse("https://maps.googleapis.com/maps/api/geocode/json?address=#{full_address}&sensor=true")
    http = Net::HTTP.new(parsed_url.host, parsed_url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(parsed_url.request_uri)
    response = http.request(request)
    json = JSON.parse(response.body)
    json['results'].each do |key|
      lat_long_arr << [key['geometry']['location']['lat'], key['geometry']['location']['lng']]
    end
    self.map_data = lat_long_arr.to_json
  end

  def remove_customer_address
    property_attr = self.attributes.except('map_data', 'created_at', 'updated_at')
    customer_address = CustomerAddress.where(property_attr).first
    if customer_address.present?
      customer_address.destroy
    end
  end

  def update_billing_address
    if self.current_customer_property
      property = Property.new
      property.street_address_1 = self.street_address_1_was
      property.street_address_2 = self.street_address_2_was
      property.city = self.city_was
      property.state_id = self.state_id_was
      property.postal_code = self.postal_code_was
      self.current_customer_property.customer.property_changed(property.attributes, self.attributes)
    end
  end
end
