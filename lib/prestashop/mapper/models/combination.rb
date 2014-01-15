using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Combination < Model
      resource :combinations
      model :combination
    
      attr_reader :id_product, :location, :ean13, :upc, :quantity, :reference, :supplier_reference, :wholesale_price, :original_price, :product_price, :ecotax, :minimal_quantity,
                  :default_on, :available_date, :quantity, :value_ids, :image_ids

      def initialize args = {}
        @id_product       = args.fetch(:id_product)
        @location         = args[:location]
        @ean13            = args[:ean]
        @upc              = args[:upc]
        @quantity         = args.fetch(:quantity, 0)
        @reference        = args.fetch(:reference)
        @supplier_reference = settings.supplier
        @wholesale_price  = args[:wholesale_price]
        @original_price   = args.fetch(:price)
        @product_price    = args.fetch(:product_price)
        @ecotax           = args[:ecotax]
        @minimal_quantity = args.fetch(:minimal_quantity, 1)
        @default_on       = args.fetch(:default_on, 0)
        @available_date   = Date.today.strftime("%F")
        @quantity         = args.fetch(:quantity, 0)
        @value_ids        = args[:value_ids]
      end

      def image_ids= image_ids
        @image_ids = image_ids
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
        if value_ids
          combination[:associations][:product_option_values] = {}
          combination[:associations][:product_option_values][:product_option_value] = hash_ids(value_ids)
        end
        if image_ids
          combination[:associations][:images] = {}
          combination[:associations][:images][:image] = hash_ids(image_ids)
        end
        combination
      end

      def create 
        combination = super
        sa = StockAvailable.find_by 'filter[id_product]' => id_product, 'filter[id_product_attribute]' => combination[:id]
        StockAvailable.update(sa, quantity: quantity)
        combination
      end

      def update id 
        update = {
          available_date: available_date
        }

        combination = Combination.update(id, update)
        if settings.update_stock
          sa = StockAvailable.find_by 'filter[id_product]' => id_product, 'filter[id_product_attribute]' => combination[:id]
          StockAvailable.update(sa, quantity: quantity)
        end
        combination
      end

      class << self
        def resolve id_product, resource, product_price
          if resource.kind_of?(Array)
            resource.each_with_index do |res, index|
              value_ids = []
              res[:options].each do |option|
                id_o = ProductOption.new(name: option[:name]).find_or_create
                value_ids << ProductOptionValue.new(name: option[:value], id_attribute_group: id_o).find_or_create
              end
              default_on = index == 0 ? 1 : 0
              combination = Combination.new(id_product: id_product, reference: res[:reference], price: res[:price], product_price: product_price, quantity: res[:quantity], default_on: default_on, value_ids: value_ids)
              current_combinations = where 'filter[id_product]' => id_product, 'filter[reference]' => res[:reference]
              if current_combinations
                current_combinations.map{|id| combination.update(id)} if settings.update_enabled
              else
                combination.image_ids = Image.upload(resource: :products, id: id_product, file: res[:images])
                combination.create
              end
            end
          end
        end

        def deactivate
          if settings.deactivate and settings.update_enabled
            first = (Date.today-365).strftime("%F")
            last = (Date.today-1).strftime("%F")
            combinations = where 'filter[date_upd]' => "[#{first},#{last}]", date: 1, 'filter[supplier_reference]' => settings.supplier, limit: 1000
            if combinations and !combinations.empty?
              combinations.map{|c| delete(c)}
            end
          end
        end
      end
    end
  end
end