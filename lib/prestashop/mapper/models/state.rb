using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class State < Model
      resource :states
      model :state
    end
  end
end