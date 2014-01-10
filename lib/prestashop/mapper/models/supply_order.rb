using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class SupplyOrder < Model
      resource :supply_orders
      model :supply_order
    end
  end
end