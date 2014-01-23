using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class ProductOptionValue < Model
      resource :product_option_values
      model :product_option_value

      attr_accessor :id, :id_attribute_group, :color, :position, :name
      attr_accessor :id_lang

      def initialize args = {}
        @id                 = args[:id]
        @id_attribute_group = args.fetch(:id_attribute_group)
        @color              = args.fetch(:color, 0)
        @position           = args[:position]
        @name               = args.fetch(:name)

        @id_lang            = args.fetch(:id_lang)
      end

      def hash
        validate!
        { name:               hash_lang(name, id_lang),
          id_attribute_group: id_attribute_group,
          color:              color }
      end

      def find_or_create
        result = self.class.find_in_cache id_attribute_group, name, id_lang
        unless result
          result = create
          Client.clear_option_values_cache
        end
        result[:id]
      end

      # Supplier must have 1/0 as active and name must be string
      def validate!
        raise ArgumentError, 'id lang must be number' unless id_lang.kind_of?(Integer)
        raise ArgumentError, 'name must string' unless name.kind_of?(String)
        raise ArgumentError, 'id attribute group must be number' unless id_attribute_group.kind_of?(Integer)
        raise ArgumentError, 'color must be true or false' unless color == 1 or color == 0
      end

      class << self
        def find_in_cache id_attribute_group, name, id_lang
          Client.option_values_cache.find{|v| v[:id_attribute_group] == id_attribute_group and v[:name].find_lang(name, id_lang)} if Client.option_values_cache
        end

        def cache
          all display: '[id,id_attribute_group,name]'
        end
      end
    end
  end
end