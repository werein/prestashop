using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class ShopGroup < Model
      resource :shop_groups
      model :shop_group
    end
  end
end