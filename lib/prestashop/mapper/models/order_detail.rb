using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class OrderDetail < Model
      resource :order_details
      model :order_detail
    end
  end
end