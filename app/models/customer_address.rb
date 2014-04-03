class CustomerAddress < ActiveRecord::Base
  belongs_to :state
  belongs_to :customer

  def full_address
    "#{street_address_1 +
        '<br/>' +
        (street_address_2.to_s=='' ? '' : street_address_2.to_s + '<br/>') +
        city + ', ' + state.short_name + ' ' + postal_code}
    ".html_safe
  end
end
