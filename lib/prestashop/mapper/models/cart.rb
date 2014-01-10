using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Cart < Model
      resource :carts
      model :cart
    end
  end
end