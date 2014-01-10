using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class ProductFeatureValue < Model
      resource :product_feature_values
      model :product_feature_value

      attr_reader :id_lang, :value, :id_feature, :custom

      def initialize args = {}
        @id_lang    = settings.id_language
        @value      = args.fetch(:value).plain
        @id_feature = args.fetch(:id_feature)
        @custom     = 0
      end

      def hash
        { value:      lang(value),
          id_feature: id_feature,
          custom:     custom }
      end
      
      def find_or_create
        result = ProductFeatureValue.find_in_cache id_feature: id_feature, value: value
        unless result
          result = create
          settings.clear_feature_values_cache
        end
        result[:id]
      end

      class << self
        def find_in_cache args = {}
          settings.feature_values_cache.find{|v| v[:id_feature][:val] == args[:id_feature] and v[:value].lang_search(args[:value])} if settings.feature_values_cache
        end

        def cache
          all display: '[id,id_feature,value]'
        end
      end
    end
  end
end