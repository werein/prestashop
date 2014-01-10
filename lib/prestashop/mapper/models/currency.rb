using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Currency < Model
      resource :currencies
      model :currency
    end
  end
end