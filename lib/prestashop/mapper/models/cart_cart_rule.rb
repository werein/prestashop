using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class CartCartRule < Model
      resource :cart_cart_rules
      model :cart_cart_rule
    end
  end
end