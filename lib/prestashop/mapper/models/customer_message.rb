using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class CustomerMessage < Model
      resource :customer_messages
      model :customer_message
    end
  end
end