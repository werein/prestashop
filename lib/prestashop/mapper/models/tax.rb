using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Tax < Model
      resource :taxes
      model :tax

      class << self
        def get_by_id_country id 
          tax_rules = TaxRule.get_by_id_country id 

          taxes = {}
          tax_rules.each do |value|
            taxes[find(value[:id_tax])[:rate].to_i.to_s] = value[:id_tax_rules_group][:val]
          end
          taxes
        end

        def get_by_country iso_code
          id_country = Country.find_by iso_code: iso_code
          get_by_id_country id_country
        end
      end
    end
  end
end