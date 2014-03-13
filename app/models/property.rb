class Property < ActiveRecord::Base
  include ActionView::Helpers::UrlHelper
  include MoneyRails::ActionViewExtension
  belongs_to :state
  has_many :customer_properties
  has_many :customers, through: :customer_properties

  def to_data_table_row
    [html_full_address, current_owner_name, html_services, humanized_money_with_symbol(balance_due), links]
  end

  def html_full_address
    "#{street_address_1 + '<br/>' + (street_address_2.to_s=='' ? '' : street_address_2.to_s + '<br/>') + city + ', ' + state.short_name + ' ' + postal_code}".html_safe
  end

  def current_customer_property
    customer_properties.where(owner: true).first
  end

  def current_owner_name
    current_customer_property ? current_customer_property.customer.name : 'No Owner'
  end

  def html_services
    if services && !services.empty?
      services.map(&:name).join('<br/>').html_safe
    else
      'No Services'
    end
  end

  def services
    if current_customer_property
      current_customer_property.workorders.map do |wo|
        wo.workorder_services.map do |wos|
          wos.service
        end
      end.flatten
    else
      nil
    end
  end

  def unpaid_invoices
    if current_customer_property
      current_customer_property.workorders.map do |wo|
        if wo.invoices
          wo.invoices.map do |invoice|
            invoice if invoice.unpaid?
          end
        else
          []
        end
      end.flatten
    else
      nil
    end
  end

  def balance_due
    if unpaid_invoices && !unpaid_invoices.empty?
      unpaid_invoices.map(&:balance_due).sum
    else
      0
    end
  end

  def links
    '<div class="btn-group btn-group-xs">' +
    "#{link_to('View',   Rails.application.routes.url_helpers.property_path(self), class: 'btn btn-default')}" +
    "#{link_to('Edit',   Rails.application.routes.url_helpers.edit_property_path(self), class: 'btn btn-default')}" +
    "#{link_to('Delete', Rails.application.routes.url_helpers.property_path(self), method: :delete, confirm: 'Are You Sure?', class: 'btn btn-danger')}" +
    '</div>'.html_safe
  end

end
