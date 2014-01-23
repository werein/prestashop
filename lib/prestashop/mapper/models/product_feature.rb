using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class ProductFeature < Model
      resource :product_features
      model :product_feature

      attr_accessor :id, :position
      attr_writer   :name
      attr_accessor :id_lang

      def initialize args = {}
        @id       = args[:id]
        @position = args[:position]
        @name     = args.fetch(:name)

        @id_lang  = args.fetch(:id_lang)
      end

      def name
        @name.plain
      end

      def hash
        validate!
        { name: hash_lang(name, id_lang) }
      end

      def find_or_create
        feature = self.class.find_in_cache name, id_lang
        unless feature
          feature = create
          Client.clear_features_cache
        end
        feature[:id]
      end

      def validate!
        raise ArgumentError, 'id lang must be number' unless id_lang.kind_of?(Integer)
        raise ArgumentError, 'name must string' unless name.kind_of?(String)
      end

      class << self
        def find_in_cache name, id_lang
          Client.features_cache.find{|k| k[:name].find_lang(name, id_lang) } if Client.features_cache
        end

        def cache
          all display: '[id,name]'
        end

        def create_from_hash resources, id_lang
          resources = [resources] if resources.kind_of?(Hash)
          if resources.kind_of?(Array)
            features = []
            resources.each do |resource|
              if resource[:feature] and !resource[:feature].empty? and resource[:value] and !resource[:value].empty?
                id_f = new(name: resource[:feature], id_lang: id_lang).find_or_create
                id_fv = ProductFeatureValue.new(value: resource[:value], id_feature: id_f, id_lang: id_lang).find_or_create
                features << { id_feature: id_f, id_feature_value: id_fv }
              end
            end 
            features
          end
        end
      end
    end
  end
end