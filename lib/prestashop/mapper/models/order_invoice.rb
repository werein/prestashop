using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class OrderInvoice < Model
      resource :order_invoices
      model :order_invoice
    end
  end
end