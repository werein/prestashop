using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class StockMovementReason < Model
      resource :stock_movement_reasons
      model :stock_movement_reason
    end
  end
end