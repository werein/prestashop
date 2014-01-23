module Prestashop
  module Client    
    class Cache
      # Cached manufacturers
      def manufacturers_cache
        @manufacturers_cache ||= Mapper::Manufacturer.cache
      end

      # Clear manufacturers cache
      def clear_manufacturers_cache
        @manufacturers_cache = nil
      end

      # Cached categories
      def categories_cache
        @categories_cache ||= Mapper::Category.cache
      end

      # Clear categories cache
      def clear_categories_cache
        @categories_cache = nil
      end

      # Cached features
      def features_cache
        @features_cache ||= Mapper::ProductFeature.cache
      end

      # Clear features cache
      def clear_features_cache
        @features_cache = nil
      end
      
      # Cached feature values
      def feature_values_cache
        @feature_values_cache ||= Mapper::ProductFeatureValue.cache
      end

      # Clear feature values cache
      def clear_feature_values_cache
        @feature_values_cache = nil
      end

      # Cached options
      def options_cache
        @options_cache ||= Mapper::ProductOption.cache
      end

      # Clear options cache
      def clear_options_cache
        @options_cache = nil
      end

      # Cached option values
      def option_values_cache
        @option_values_cache ||= Mapper::ProductOptionValue.cache
      end

      # Clear option values cache
      def clear_option_values_cache
        @option_values_cache = nil
      end
    end
  end
end