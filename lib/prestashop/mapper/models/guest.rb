using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Guest < Model
      resource :guests
      model :guest
    end
  end
end