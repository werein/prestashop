using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Group < Model
      resource :groups
      model :group
    end
  end
end