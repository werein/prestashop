using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Store < Model
      resource :stores
      model :store
    end
  end
end