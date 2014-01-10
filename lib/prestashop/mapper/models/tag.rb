using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Tag < Model
      resource :tags
      model :tag
    end
  end
end