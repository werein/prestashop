using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Delivery < Model
      resource :deliveries
      model :delivery
    end
  end
end