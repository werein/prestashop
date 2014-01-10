using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class ProductOption < Model
      resource :product_options
      model :product_option

      attr_reader :id_lang, :group_type, :name

      def initialize args = {}
        @id_lang = settings.id_language
        @group_type = args.fetch(:group_type, 'select')
        @name    = args.fetch(:name)
      end

      def hash
        { group_type: group_type,
          name: lang(name),
          public_name: lang(name) }
      end

      def find_or_create
        option = ProductOption.find_in_cache name: name
        unless option
          option = create
          settings.clear_options_cache
        end
        option[:id]
      end

      class << self
        def find_in_cache args = {}
          settings.options_cache.find{|k| k[:name].lang_search(args[:name]) } if settings.options_cache
        end

        def cache
          all display: '[id,name]'
        end
      end
    end
  end
end