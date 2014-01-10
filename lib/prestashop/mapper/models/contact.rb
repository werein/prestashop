using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Contact < Model
      resource :contacts
      model :contact
    end
  end
end