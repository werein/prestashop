using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Combination < Model
      resource :combinations
      model :combination
    
      attr_accessor :id_product, :location, :ean13, :upc, :quantity, :reference, :supplier_reference, :wholesale_price, :original_price, :product_price, :ecotax, :minimal_quantity,
                  :default_on, :available_date, :quantity

      attr_reader :product_options, :images

      def initialize args = {}
        @id_product       = args.fetch(:id_product)
        @location         = args[:location]
        @ean13            = args[:ean]
        @upc              = args[:upc]
        @quantity         = args.fetch(:quantity, 0)
        @reference        = args.fetch(:reference)
        @supplier_reference = Client.supplier
        @wholesale_price  = args[:wholesale_price]
        @original_price   = args[:original_price]
        @product_price    = args[:product_price]
        @ecotax           = args[:ecotax]
        @minimal_quantity = args.fetch(:minimal_quantity, 1)
        @default_on       = args.fetch(:default_on, 0)
        @available_date   = Date.today.strftime("%F")
        @quantity         = args.fetch(:quantity, 0)
      end

      def vat
        original_price ? original_price[:vat] : 0
      end

      def price
        original_price ? product_price + Helper.calculate_price(original_price, vat) : 0
      end

      def hash
        combination = {
          id_product:         id_product,
          reference:          reference,
          supplier_reference: supplier_reference,
          minimal_quantity:   minimal_quantity,
          default_on:         default_on,
          available_date:     available_date,
          price:              price,
          quantity:           quantity,
          associations: {}
        }
        if product_options
          combination[:associations][:product_option_values] = {}
          combination[:associations][:product_option_values][:product_option_value] = hash_ids(product_options)
        end
        if images
          combination[:associations][:images] = {}
          combination[:associations][:images][:image] = hash_ids(images)
        end
        combination
      end

      # Find combination by +reference+ and +id_product+, returns +id+
      def id
        @id ||= self.class.find_by 'filter[reference]' => reference, 'filter[id_product]' => id_product
      end
      alias :find? :id

      def create 
        response = super
        if response
          StockAvailable.new(id_product: id_product, id_product_attribute: response[:id]).update(quantity: quantity)
        end
        response
      end

      def update options = {}
        self.class.update(id, options)
      end

      def product_options= product_options
        @product_options = []
        product_options.each do |product_option|
          id_o = ProductOption.new(name: product_option[:name]).find_or_create
          @product_options << ProductOptionValue.new(name: product_option[:value], id_attribute_group: id_o).find_or_create
        end
      end

      def images= images
        @images = Image.new(resource: 'products', resource_id: id_product, source: images).upload
      end

      class << self
        def deactivate supplier
          first = (Date.today-365).strftime("%F")
          last = (Date.today-1).strftime("%F")
          combinations = where 'filter[date_upd]' => "[#{first},#{last}]", date: 1, 'filter[supplier_reference]' => supplier, limit: 1000
          if combinations and !combinations.empty?
            combinations.map{|c| delete(c)}
          end
        end
      end
    end
  end
end