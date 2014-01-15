using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class ProductOption < Model
      resource :product_options
      model :product_option

      attr_accessor :id_lang, :is_color_group, :position, :group_type, :name, :public_name

      def initialize args = {}
        @id_lang      = args.fetch(:id_lang, Client.id_language)
        @is_color_group = args.fetch(:is_color_group, 0)
        @position     = args[:position]
        @group_type   = args.fetch(:group_type, 'select')
        @name         = args.fetch(:name)
        @public_name  = args[:public_name]
      end

      def public_name
        @public_name ? @public_name : name
      end

      def hash
        validate!

        { is_color_group: is_color_group,
          position: position,
          group_type: group_type,
          name: hash_lang(name, id_lang),
          public_name: hash_lang(public_name, id_lang) }
      end

      def find_or_create
        option = self.class.find_in_cache name, id_lang
        unless option
          option = create
          Client.clear_options_cache
        end
        option[:id]
      end

      def validate!
        raise ArgumentError, 'id lang must be number' unless id_lang.kind_of?(Integer)
        raise ArgumentError, 'name must string' unless name.kind_of?(String)
        raise ArgumentError, 'group_type must string' unless group_type.kind_of?(String)
      end

      class << self
        def find_in_cache name, id_lang
          Client.options_cache.find{|k| k[:name].lang_search(name, id_lang) } if Client.options_cache
        end

        def cache
          all display: '[id,name]'
        end
      end
    end
  end
end