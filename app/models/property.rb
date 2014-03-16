class Property < ActiveRecord::Base
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
    invoices.map{|invoice| invoice if invoice.unpaid?} if invoices
  end

  def balance_due
    unpaid_invoices.map(&:balance_due).sum if unpaid_invoices
  end

  def links
    "#{link_to('View', Rails.application.routes.url_helpers.property_path(self), class: 'btn btn-default btn-sm')}".html_safe
  end

end
