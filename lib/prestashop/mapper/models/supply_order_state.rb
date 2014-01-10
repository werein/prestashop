using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class SupplyOrderState < Model
      resource :supply_order_states
      model :supply_order_state
    end
  end
end