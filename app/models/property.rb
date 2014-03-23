class Property < ActiveRecord::Base
  require 'net/http'
  include ActionView::Helpers::UrlHelper
  include MoneyRails::ActionViewExtension
  belongs_to :state
  has_many :customer_properties
  has_many :customers, through: :customer_properties

  def to_data_table_row
    [html_full_address, current_owner_name, html_services, humanized_money_with_symbol(balance_due || 0)]
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

  def workorders
    current_customer_property ? current_customer_property.try(:workorders) : []
  end

  def has_active_workorders?
    workorders.empty? ? false : workorders.active.count > 0
  end

  def html_services
    unless services.nil? || services.try(:empty?)
      services.map(&:name).join('<br/>').html_safe
    else
      'No Services'
    end
  end

  def services
    if workorders
      workorders.map(&:workorder_services).flatten.map(&:service).flatten
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
      unpaid_invoices.map(&:balance_due).sum
    end
  end

  def links
    "#{link_to('View', Rails.application.routes.url_helpers.property_path(self), class: 'btn btn-default btn-sm')}".html_safe
  end

  def self.generate_map_data
    lat_long_arr = []
    all.map do |property|
      parsed_url = URI.parse("https://maps.googleapis.com/maps/api/geocode/json?address=#{property.full_address}&sensor=true")
      http = Net::HTTP.new(parsed_url.host, parsed_url.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(parsed_url.request_uri)
      response = http.request(request)
      json = JSON.parse(response.body)
      json['results'].each do |key|
        lat_long_arr << [key['geometry']['location']['lat'], key['geometry']['location']['lng']]
      end
      lat_long_arr
    end
  end

end
