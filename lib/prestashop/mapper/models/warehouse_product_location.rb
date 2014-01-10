using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class WarehouseProductLocation < Model
      resource :warehouse_product_locations
      model :warehouse_product_location
    end
  end
end