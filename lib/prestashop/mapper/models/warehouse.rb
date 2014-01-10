using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Warehouse < Model
      resource :warehouses
      model :warehouse
    end
  end
end