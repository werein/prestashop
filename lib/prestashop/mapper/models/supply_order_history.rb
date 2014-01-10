using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class SupplyOrderHistory < Model
      resource :supply_order_histories
      model :supply_order_history
    end
  end
end