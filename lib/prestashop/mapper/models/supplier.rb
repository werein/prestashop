using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Supplier < Model
      resource :suppliers
      model :supplier

      attr_accessor :id, :link_rewrite, :name, :active, :description, :meta_title, :meta_description, :meta_keywords
      attr_accessor :id_lang

      def initialize args = {}
        @id               = args[:id]
        @link_rewrite     = args[:link_rewrite]
        @name             = args.fetch(:name)
        @active           = args.fetch(:active, 1)
        # date_add
        # date_upd
        @description      = args[:description]
        @meta_title       = args[:meta_title]
        @meta_description = args[:meta_description]
        @meta_keywords    = args[:meta_keywords]

        @id_lang          = args[:id_lang]
      end

      # Hash is used as default source for #create
      def hash
        validate!
        { active: active, name: name }
      end

      # Find or create supplier from hash
      def find_or_create
        supplier = self.class.find_by 'filter[name]' => name
        supplier ? supplier : create[:id]
      end

      # Supplier must have 1/0 as active and name must be string
      def validate!
        raise ArgumentError, 'active must be 0 or 1' unless active == 0 or active == 1
        raise ArgumentError, 'name must string' unless name.kind_of?(String)
      end
    end
  end
end