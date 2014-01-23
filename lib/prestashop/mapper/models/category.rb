using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Category < Model
      resource :categories
      model :category

      attr_accessor :id_lang
      attr_accessor :id, :id_parent, :level_depth, :active, :id_shop_default, :is_root_category, :position
      attr_writer   :name, :description, :link_rewrite

      def initialize args = {}
        @id               = args[:id]
        @id_parent        = args.fetch(:id_parent, 2)
        @level_depth      = args[:level_depth]
        # nb_products_recursive
        @active           = args.fetch(:active, 1)
        @id_shop_default  = args.fetch(:id_shop_default, 1)
        @is_root_category = 0
        @position         = args[:position]
        # date_add
        # date_upd
        @name             = args.fetch(:name)
        @link_rewrite     = args[:link_rewrite]
        @description      = args[:description]
        @meta_title       = args[:meta_title]
        @meta_description = args[:meta_description]
        @meta_keywords    = args[:meta_keywords]

        @id_lang          = args.fetch(:id_lang)
      end

      # Category name can't have some symbols and can't be longer than 63
      def name
        @name.plain.truncate(61)
      end

      # Description can have additional symbols and can't be longer than 255
      def description
        @description.restricted.truncate(252) if @description
      end

      # Link rewrite must be usable in uri
      def link_rewrite
        @link_rewrite ? @link_rewrite.parameterize : name.parameterize
      end

      # Category hash structure, which will be converted to XML
      def hash
        { id_parent:        id_parent,
          active:           active ,
          id_shop_default:  id_shop_default,
          is_root_category: is_root_category,
          name:             hash_lang(name, id_lang),
          link_rewrite:     hash_lang(link_rewrite, id_lang),
          description:      hash_lang(description, id_lang),
          meta_title:       hash_lang(name, id_lang),
          meta_description: hash_lang(description, id_lang),
          meta_keywords:    hash_lang(meta_keywords, id_lang) }
      end

      # Find category by name and id parent, create new one from hash, when doesn't exist
      def find_or_create
        category = self.class.find_in_cache id_parent, name, id_lang
        unless category
          category = create
          Client.clear_categories_cache
        end
        category[:id]
      end

      class << self

        # Search for category based on args on cached categories, see #cache and #Client::Settings.categories_cache
        # Returns founded category or nil
        #
        def find_in_cache id_parent, name, id_lang
          Client.categories_cache.find{ |c| c[:id_parent] == id_parent and c[:name].find_lang(name, id_lang) }
        end

        # Requesting all on Prestashop API, displaying id, id_parent, name
        def cache
          all display: '[id, id_parent, name]'
        end

        # Create new category based on given param, delimited by delimiter in settings
        #
        # ==== Example:
        #   Category.create_from_name('Apple||iPhone', 2) # => [1, 2]
        #
        def create_from_name category_name, id_lang
          if category_name and !category_name.empty?
            names = [category_name.split('||')].flatten!
            categories = []
            id_parent = 2
            names.each do |name|
              id_parent = new(name: name, id_parent: id_parent, id_lang: id_lang).find_or_create
              categories << id_parent
            end
            categories
          end
        end

        def create_from_names category_names, id_lang
          categories = []
          category_names.each do |category_name|
            categories << create_from_name(category_name, id_lang)
          end
          categories.flatten.uniq
        end
      end
    end
  end
end