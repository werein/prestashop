using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Carrier < Model
      resource :carriers
      model :carrier
    end
  end
end