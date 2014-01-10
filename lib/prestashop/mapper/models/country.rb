using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Country < Model
      resource :countries
      model :country

      class << self
        def find_by_iso_code iso_code
          find_by 'filter[iso_code]' => iso_code
        end
      end
    end
  end
end