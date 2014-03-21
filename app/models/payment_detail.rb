class PaymentDetail < ActiveRecord::Base
  belongs_to :invoice

  CC_TYPES = %w(Visa Mastercard American\ Express Discover)

  def amount
    cash_subtotal + check_subtotal + cc_subtotal
  end

end
