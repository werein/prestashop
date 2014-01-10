using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Shop < Model
      resource :shops
      model    :shop
    end
  end
end