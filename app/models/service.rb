class Service < ActiveRecord::Base
  include MoneyRails::ActionViewExtension
  include ActionView::Helpers::UrlHelper
  has_many :workorder_services
  has_many :workorders, through: :workorder_services

  def to_data_table_row
    [self.name, humanized_money_with_symbol(self.base_cost), edit_link, destroy_link]
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
