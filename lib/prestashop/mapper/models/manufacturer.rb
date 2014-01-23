using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Manufacturer < Model
      resource :manufacturers
      model    :manufacturer

      attr_accessor :id, :active
      attr_accessor :id_lang
      attr_writer :link_rewrite, :name, :description, :short_description, :meta_title, :meta_description, :meta_keywords

      def initialize args = {}
        @id                 = args[:id]
        @active             = args.fetch(:active, 1)
        @link_rewrite       = args[:link_rewrite]
        @name               = args[:name]
        # date_add
        # date_upd
        @description        = args[:description]
        @short_description  = args[:short_description]
        @meta_title         = args[:meta_title]
        @meta_description   = args[:meta_description]
        @meta_keywords      = args[:meta_keywords]

        @id_lang            = args.fetch(:id_lang)
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
        validate!
        { active:             active,
          name:               name,
          description:        hash_lang(description, id_lang),
          short_description:  hash_lang(short_description, id_lang),
          meta_title:         hash_lang(name, id_lang),
          meta_description:   hash_lang(short_description, id_lang),
          meta_keywords:      hash_lang(meta_keywords, id_lang) }      
      end

      def find_or_create
        if name and !name.empty?
          manufacturer = self.class.find_in_cache name
          unless manufacturer
            manufacturer = create
            Client.clear_manufacturers_cache
          end
          manufacturer[:id]
        end
      end

      def validate!
        raise ArgumentError, 'id lang must be number' unless id_lang.kind_of?(Integer)
        raise ArgumentError, 'active must be number' unless active.kind_of?(Integer)
        raise ArgumentError, 'name must string' unless name.kind_of?(String)
      end

      class << self
        def find_in_cache name
          Client.manufacturers_cache.find{|m| m[:name] == name } if Client.manufacturers_cache
        end

        def cache
          all display: '[id,name]'
        end
      end
    end
  end
end