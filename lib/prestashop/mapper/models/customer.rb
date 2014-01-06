module Prestashop
  module Mapper
    class Customer < Model
      resource :customers
      model :customer
    end
  end
end