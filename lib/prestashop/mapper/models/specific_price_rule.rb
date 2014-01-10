using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class SpecificPriceRule < Model
      resource :specific_price_rules
      model :specific_price_rule
    end
  end
end