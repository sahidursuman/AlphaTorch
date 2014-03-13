class PaymentDetail < ActiveRecord::Base
  belongs_to :invoice

  def amount
    cash_subtotal + check_subtotal + cc_subtotal
  end

end
