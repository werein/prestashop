using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Zone < Model
      resource :zones
      model :zone
    end
  end
end