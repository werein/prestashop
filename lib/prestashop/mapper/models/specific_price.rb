using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class SpecificPrice < Model
      resource :specific_prices
      model :specific_price
    end
  end
end