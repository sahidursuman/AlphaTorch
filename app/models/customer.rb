class Customer < ActiveRecord::Base
  include ActionView::Helpers::UrlHelper
  include MoneyRails::ActionViewExtension
  require 'model_locking'
  include ModelLocking

  belongs_to :status, primary_key: 'status_code', foreign_key: 'status_code'
  has_many :customer_addresses
  has_many :customer_properties
  has_many :properties, through: :customer_properties

  def to_data_table_row
    [html_name, first_phone, second_phone, email_address, html_addresses, humanized_money_with_symbol(balance_due)]
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

  def current_customer_properties
    customer_properties.where(owner: true)
  end

  def name
    mi = (self.middle_initial.nil? || self.middle_initial.empty?) ? '' : self.middle_initial + '. '
    self.first_name + ' ' + mi + self.last_name
  end

  def html_name
    link_to name.html_safe, Rails.application.routes.url_helpers.customer_path(self)
  end

  def workorders
    if customer_properties.present?
      customer_properties.map(&:workorders).compact.flatten
    else
      []
    end
  end

  def invoices
    if workorders.present?
      workorders.map(&:invoices).compact.flatten
    else
      []
    end
  end

  def balance_due
    if invoices.present?
      invoices.map(&:balance_due).sum
    else
      0
    end
  end

  def change_status(status)
    case status
      when 'Active'
        remove_hold
      when 'Locked'
        set_on_hold
    end
  end

  def set_on_hold
    unless status_code == Status.get_code('Locked')
      self.status_code = Status.get_code('Locked')
      self.save
      current_customer_properties.each{|cp| cp.change_status('Locked')}
    end
  end

  def remove_hold
    unless status_code == Status.get_code('Active')
      self.status_code = Status.get_code('Active')
      self.save
      current_customer_properties.each{|cp| cp.change_status('Active')}
    end
  end

  def html_addresses
    customer_properties.where(owner: true).map do |cp|
        cp.property.html_full_address
    end.join('<br/><br/>'.html_safe)
  end

end
