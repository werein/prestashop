using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class OrderCartRule < Model
      resource :order_cart_rules
      model :order_cart_rule
    end
  end
end