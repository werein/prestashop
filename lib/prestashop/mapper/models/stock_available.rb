using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class StockAvailable < Model
      resource :stock_availables
      model :stock_available

      attr_accessor :id_product, :id_product_attribute, :id_shop, :id_shop_group, :quantity, :depends_on_stock, :out_of_stock

      def initialize args = {}
        @id                   = args[:id]
        @id_product           = args[:id_product]
        @id_product_attribute = args.fetch(:id_product_attribute, 0)
        @id_shop              = args.fetch(:id_shop, 1)
        @id_shop_group        = args.fetch(:id_shop_group, 0)
        @quantity             = args.fetch(:quantity, 0)
        @depends_on_stock     = args.fetch(:depends_on_stock, 0)
        @out_of_stock         = args.fetch(:out_of_stock, 2)
      end

      def id
        @id ||= if id_product_attribute == 0
          self.class.find_by 'filter[id_product]' => id_product
        else
          self.class.find_by 'filter[id_product]' => id_product, 'filter[id_product_attribute]' => id_product_attribute
        end
      end
      alias :find? :id

      def update options = {}
        self.class.update(id, options) if find?
      end
    end
  end
end