using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class ProductSupplier < Model
      resource :product_suppliers
      model :product_supplier

      attr_reader :id_product, :id_product_attribute, :id_supplier, :product_supplier_reference, :product_supplier_price_te, :id_currency

      def initialize args = {}
        @id_supplier          = args.fetch(:id_supplier)
        @id_product           = args.fetch(:id_product)
        @id_product_attribute = args.fetch(:id_product_attribute, 0)
        @id_currency          = args.fetch(:id_currency, 0)

        @product_supplier_reference = args[:product_supplier_reference]
        @product_supplier_price_te  = args[:product_supplier_price_te]
      end

      def hash
        { id_product:                 id_product,
          id_product_attribute:       id_product_attribute,
          id_supplier:                id_supplier,
          product_supplier_reference: product_supplier_reference,
          product_supplier_price_te:  product_supplier_price_te,
          id_currency:                id_currency }
      end
    end
  end
end
