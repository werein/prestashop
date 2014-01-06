module Prestashop
  module Mapper
    class Manufacturer < Model
      resource :manufacturers
      model    :manufacturer

      attr_reader :active

      def initialize args = {}
        @active             = args.fetch(:active, 1)
        @name               = args.fetch(:name)
        @description        = args[:description]
        @short_description  = args[:short_description]
        @meta_title         = args[:meta_title]
        @meta_description   = args[:meta_description]
        @meta_keywords      = args[:meta_keywords]
      end

      def name
        @name.plain.truncate(125)
      end

      def description
        @description.plain.truncate(252) if @description
      end

      def short_description
        @short_description ? @short_description.plain.truncate(252) : ( description.plain.truncate(252) if description )
      end

      def hash
        { active:             active,
          name:               name,
          description:        lang(description),
          short_description:  lang(short_description),
          meta_title:         lang(name),
          meta_description:   lang(short_description),
          meta_keywords:      lang(meta_keywords) }      
      end

      def find_or_create
        manufacturer = Manufacturer.find_in_cache name: name
        unless manufacturer
          manufacturer = create
          settings.clear_manufacturers_cache
        end
        manufacturer[:id]
      end

      class << self
        def find_in_cache args = {}
          settings.manufacturers_cache.find{|m| m[:name] == args[:name] } if settings.manufacturers_cache
        end

        def cache
          all display: '[id, name]'
        end

        def resolver resource
          if resource.kind_of?(String) and !resource.empty?
            new(name: resource).find_or_create
          end
        end
      end
    end
  end
end