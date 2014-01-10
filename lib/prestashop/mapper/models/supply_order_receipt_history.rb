using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class SupplyOrderReceiptHistory < Model
      resource :supply_order_receipt_histories
      model :supply_order_receipt_history
    end
  end
end