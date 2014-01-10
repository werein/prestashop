using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class ProductFeature < Model
      resource :product_features
      model :product_feature

      attr_reader :id_lang, :name

      def initialize args = {}
        @id_lang = settings.id_language
        @name    = args.fetch(:name).plain
      end

      def hash
        { name: lang(name) }
      end

      def find_or_create
        feature = ProductFeature.find_in_cache name: name
        unless feature
          feature = create
          settings.clear_features_cache
        end
        feature[:id]
      end

      class << self
        def find_in_cache args = {}
          settings.features_cache.find{|k| k[:name].lang_search(args[:name]) } if settings.features_cache
        end

        def cache
          all display: '[id,name]'
        end

        def resolver resource
          if resource.kind_of?(Array)
            features = []
            resource.each do |res|
              if res[:feature] and !res[:feature].empty? and res[:value] and !res[:value].empty?
                id_f = new(name: res[:feature]).find_or_create
                id_fv = ProductFeatureValue.new(value: res[:value], id_feature: id_f).find_or_create
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