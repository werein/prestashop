using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class TaxRuleGroup < Model
      resource :tax_rule_groups
      model :tax_rule_group
    end
  end
end