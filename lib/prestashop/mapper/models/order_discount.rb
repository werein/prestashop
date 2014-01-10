using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class OrderDiscount < Model
      resource :order_discounts
      model :order_discount
    end
  end
end