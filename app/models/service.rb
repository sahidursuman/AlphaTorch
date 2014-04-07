class Service < ActiveRecord::Base
  include MoneyRails::ActionViewExtension
  include ActionView::Helpers::UrlHelper
  has_many :workorder_services
  has_many :workorders, through: :workorder_services

  validates_presence_of :name
  validates_presence_of :base_cost
  validates_numericality_of :base_cost

  def base_cost_dollars
    if self.base_cost
      if self.base_cost.is_a?(Integer)
        return self.base_cost / 100.00
      elsif self.base_cost.is_a?(String)
        return ''
      end
    else
      return nil
    end
  end

  def base_cost_dollars=(amount)
    self.base_cost = (Float(amount) * 100).to_i
  rescue
    self.base_cost = amount
  end

  def to_data_table_row
    [self.name, humanized_money_with_symbol(self.base_cost_dollars), edit_link, destroy_link]
  end

  def edit_link
    link_to 'Edit',
    Rails.application.routes.url_helpers.edit_service_path(self),
    remote:true,
    id:'edit_service_link'
  end

  def destroy_link
    link_to 'Destroy',
    Rails.application.routes.url_helpers.service_path(self),
    remote:true,
    method: :delete,
    id:'destroy_service_link',
    data:{confirm:'Are you sure?'}
  end

end
