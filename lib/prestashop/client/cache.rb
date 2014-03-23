module Prestashop
  module Client    
    class Cache
      def manufacturers_cache
        @manufacturers_cache ||= Mapper::Manufacturer.cache
      end

      def clear_manufacturers_cache
        @manufacturers_cache = nil
      end

      def categories_cache
        @categories_cache ||= Mapper::Category.cache
      end

      def clear_categories_cache
        @categories_cache = nil
      end

      def features_cache
        @features_cache ||= Mapper::ProductFeature.cache
      end

      def clear_features_cache
        @features_cache = nil
      end
      
      def feature_values_cache
        @feature_values_cache ||= Mapper::ProductFeatureValue.cache
      end

      def clear_feature_values_cache
        @feature_values_cache = nil
      end

      def options_cache
        @options_cache ||= Mapper::ProductOption.cache
      end

      def clear_options_cache
        @options_cache = nil
      end

      def option_values_cache
        @option_values_cache ||= Mapper::ProductOptionValue.cache
      end

      def clear_option_values_cache
        @option_values_cache = nil
      end
    end
  end
end