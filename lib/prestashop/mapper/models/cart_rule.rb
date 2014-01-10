using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class CartRule < Model
      resource :cart_rules
      model :cart_rule
    end
  end
end