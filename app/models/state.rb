class State < ActiveRecord::Base
  include ActionView::Helpers::UrlHelper
  belongs_to :country
  has_many :customer_addresses
  has_many :properties

  def to_data_table_row
    [self.name, self.short_name, self.country.name, edit_link, destroy_link]
  end

  def edit_link
    link_to 'Edit',
    Rails.application.routes.url_helpers.edit_state_path(self),
    remote:true,
    id:'edit_state_link'
  end

  def destroy_link
    link_to 'Destroy',
    Rails.application.routes.url_helpers.state_path(self),
    remote:true,
    method: :delete,
    id:'destroy_state_link',
    data:{confirm:'Are you sure?'}
  end
end
