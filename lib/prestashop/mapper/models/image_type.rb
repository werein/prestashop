using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class ImageType < Model
      resource :image_types
      model :image_type
    end
  end
end