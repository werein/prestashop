using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class StockAvailable < Model
      resource :stock_availables
      model :stock_available
    end
  end
end