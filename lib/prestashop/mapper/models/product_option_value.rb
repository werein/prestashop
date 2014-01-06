module Prestashop
  module Mapper
    class ProductOptionValue < Model
      resource :product_option_values
      model :product_option_value

      attr_reader :id_lang, :name, :id_attribute_group, :color

      def initialize args = {}
        @id_lang    = settings.id_language
        @name       = args.fetch(:name)
        @id_attribute_group = args.fetch(:id_attribute_group)
        @color      = 0
      end

      def hash
        { name:               lang(name),
          id_attribute_group: id_attribute_group,
          color:              color }
      end

      def find_or_create
        result = ProductOptionValue.find_in_cache id_attribute_group: id_attribute_group, name: name
        unless result
          result = create
          settings.clear_option_values_cache
        end
        result[:id]
      end

      class << self
        def find_in_cache args = {}
          settings.option_values_cache.find{|v| v[:id_attribute_group][:val] == args[:id_attribute_group] and v[:name].lang_search(args[:name])} if settings.option_values_cache
        end

        def cache
          all display: '[id,id_attribute_group,name]'
        end
      end
    end
  end
end