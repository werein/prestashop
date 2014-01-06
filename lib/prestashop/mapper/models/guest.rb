module Prestashop
  module Mapper
    class Guest < Model
      resource :guests
      model :guest
    end
  end
end