using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class OrderPayment < Model
      resource :order_payments
      model :order_payment
    end
  end
end