using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Stock < Model
      resource :stocks
      model :stock
    end
  end
end