using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class WeightRange < Model
      resource :weight_ranges
      model :weight_range
    end
  end
end