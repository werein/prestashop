using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class ProductFeatureValue < Model
      resource :product_feature_values
      model :product_feature_value

      attr_accessor :id, :id_feature, :custom
      attr_writer   :value
      attr_accessor :id_lang

      def initialize args = {}
        @id         = args[:id]
        @id_feature = args.fetch(:id_feature)
        @custom     = args.fetch(:custom, 0)
        @value      = args.fetch(:value)

        @id_lang    = args.fetch(:id_lang)
      end

      def value
        @value.plain
      end

      def hash
        validate!

        { id_feature: id_feature,
          custom:     custom,
          value:      hash_lang(value, id_lang) }
      end
      
      def find_or_create
        result = self.class.find_in_cache id_feature, value, id_lang
        unless result
          result = create
          Client.clear_feature_values_cache
        end
        result[:id]
      end

      def validate!
        raise ArgumentError, 'id lang must be number' unless id_lang.kind_of?(Integer)
        raise ArgumentError, 'id feature must string' unless id_feature.kind_of?(Integer)
        raise ArgumentError, 'custom must be 0 or 1' unless custom == 0 or custom == 1
        raise ArgumentError, 'value must string' unless value.kind_of?(String)
      end

      class << self
        def find_in_cache id_feature, value, id_lang
          Client.feature_values_cache.find{|v| v[:id_feature] == id_feature and v[:value].find_lang(value, id_lang)} if Client.feature_values_cache
        end

        def cache
          all display: '[id,id_feature,value]'
        end
      end
    end
  end
end