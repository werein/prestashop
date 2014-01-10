using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Category < Model
      resource :categories
      model :category

      attr_reader :id_parent, :id_shop_default, :active, :is_root_category

      def initialize args = {}
        @id_parent        = args.fetch(:id_parent, 2)
        @id_shop_default  = args.fetch(:id_shop_default, 1)
        @active           = args.fetch(:active, 1)
        @is_root_category = 0
        @name             = args.fetch(:name)
        @description      = args[:description]
        @link_rewrite     = args[:link_rewrite]
        @meta_title       = args[:meta_title]
        @meta_description = args[:meta_description]
        @meta_keywords    = args[:meta_keywords]
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
          id_shop_default:  id_shop_default,
          active:           active ,
          is_root_category: is_root_category,
          name:             lang(name),
          description:      lang(description),
          link_rewrite:     lang(link_rewrite),
          meta_title:       lang(name),
          meta_description: lang(description),
          meta_keywords:    lang(meta_keywords) }
      end

      # Find category by name and id parent, create new one from hash, when doesn't exist
      def find_or_create
        category = Category.find_in_cache name: name, id_parent: id_parent
        unless category
          category = create
          settings.clear_categories_cache
        end
        category[:id]
      end

      class << self

        # Search for category based on args on cached categories, see #cache and #Client::Settings.categories_cache
        # Returns founded category or nil
        #
        # ==== Parameters:
        # opts [Hash]:
        #   * +:id_parent+  - Parent category
        #   * +:name+       - Name of category
        #
        def find_in_cache args = {}
          found = settings.categories_cache.find do |c| 
            c[:id_parent][:val] == args[:id_parent] and c[:name].lang_search(args[:name]) unless c[:id_parent] == 0
          end
        end

        # Requesting all on Prestashop API, displaying id, id_parent, name
        def cache
          all display: '[id, id_parent, name]'
        end

        # Create new category based on given param, delimited by delimiter in settings
        #
        # ==== Example:
        #   Category.create_from_name('Apple|iPhone') # => [1, 2]
        #
        def create_from_name category_name
          if category_name and !category_name.empty?
            names = [category_name.split(settings.delimiter)].flatten!
            categories = []
            id_parent = 2
            names.each do |name|
              id_parent = new(name: name, id_parent: id_parent).find_or_create
              categories << id_parent
            end
            categories
          end
        end

        # Create categories, from string, hash or array
        def resolver resource
          case [resource.class]
          when [String]
            categories = create_from_name resource
            default_category = categories.last if categories
          when [Array]
            categories = []
            resource.each do |res|
              categories.concat create_from_name(res)
            end
            default_category = categories.last if categories
          when [Hash]
            if resource[:default]
              categories = create_from_name resource[:default]
              default_category = categories.last if categories
              if resource[:secondary]
                resource[:secondary].each do |secondary|
                  categories << create_from_name(secondary)
                end
              end
            end    
          end
          { id_category_default: default_category, ids_category: categories }
        end
      end
    end
  end
end