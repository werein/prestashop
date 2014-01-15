using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Supplier < Model
      resource :suppliers
      model :supplier

      attr_accessor :active, :name

      def initialize args = {}
        @active = args.fetch(:active, 1)
        @name = args.fetch(:name)
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