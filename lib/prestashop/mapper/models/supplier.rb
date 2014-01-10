using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Supplier < Model
      resource :suppliers
      model :supplier

      attr_reader :active, :name

      def initialize args = {}
        @active = args.fetch(:active, 1)
        @name = args.fetch(:name)
      end

      def hash
        { active: active,
          name: name }
      end

      def find_or_create
        supplier = Supplier.find_by 'filter[name]' => name
        supplier ? supplier : create[:id]
      end
    end
  end
end