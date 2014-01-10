using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class OrderState < Model
      resource :order_states
      model :order_state
    end
  end
end