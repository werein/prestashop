using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class StockMovement < Model
      resource :stock_movements
      model :stock_movement
    end
  end
end