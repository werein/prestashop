using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class OrderCarrier < Model
      resource :order_carriers
      model :order_carrier
    end
  end
end