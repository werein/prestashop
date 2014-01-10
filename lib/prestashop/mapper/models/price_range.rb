using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class PriceRange < Model
      resource :price_ranges
      model :price_range
    end
  end
end