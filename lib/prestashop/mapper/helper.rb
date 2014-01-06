module Prestashop
  module Mapper
    module Helper
      def self.calculate_price original_price, vat
        case [original_price.class]
        when [Numeric]
          original_price.round(4)
        when [String]
          original_price.to_f.round(4)
        when [Hash]
          if original_price[:price]
            price = original_price[:price].to_f
            price = price + (vat.to_f * price / 100) unless Client.settings.vat_enabled
          else
            price = Client.settings.vat_enabled ? without_vat(original_price[:price_vat].to_f, vat) : original_price[:price_vat].to_f
          end
          if original_price[:config]     
            if original_price[:config][:adjustment] =~ /^increase\z|^decrease\z/ and original_price[:config][:adjustment_type] =~ /^fee\z|^percentage\z/
              adjustment = original_price[:config][:adjustment]
              adjustment_type = original_price[:config][:adjustment_type]
              adjustment_value = original_price[:config][:adjustment_value].to_f
              
              change = adjustment_type == 'fee' ? adjustment_value : adjustment_value * price / 100
              value = adjustment == 'increase' ? change : -change

              price = price + value
            end
          end
          price.round(4)
        end
      end

      def self.without_vat price_vat, vat
        with_vat = vat.to_f + 100
        coe = 100 / with_vat
        price_vat.to_f * coe
      end
    end
  end
end