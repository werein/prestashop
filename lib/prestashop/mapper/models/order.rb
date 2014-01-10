using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Order < Model
      resource :orders
      model :order
    end
  end
end