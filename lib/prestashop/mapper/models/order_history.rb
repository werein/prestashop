module Prestashop
  module Mapper
    class OrderHistory < Model
      resource :order_histories
      model :order_history
    end
  end
end