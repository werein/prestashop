using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Address < Model
      resource :addresses
      model :address
    end
  end
end