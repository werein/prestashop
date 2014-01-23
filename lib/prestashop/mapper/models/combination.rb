using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Combination < Model
      resource :combinations
      model :combination
    
      attr_accessor :id_lang, :id_product_options, :id_images
      attr_accessor :id, :id_product, :location, :ean13, :upc, :quantity, :reference, :supplier_reference, :wholesale_price,
                    :price, :ecotax, :weight, :unit_price_impact, :minimal_quantity, :default_on, :available_date

      def initialize args = {}
        @id                 = args[:id]
        @id_product         = args.fetch(:id_product)
        @location           = args[:location]
        @ean13              = args[:ean]
        @upc                = args[:upc]
        @quantity           = args.fetch(:quantity, 0)
        @reference          = args.fetch(:reference)
        @supplier_reference = args[:supplier_reference]
        @wholesale_price    = args[:wholesale_price]
        @price              = args[:price]
        @ecotax             = args[:ecotax]
        @weight             = args[:weight]
        @unit_price_impact  = args[:unit_price_impact]
        @minimal_quantity   = args.fetch(:minimal_quantity, 1)
        @default_on         = args.fetch(:default_on, 0)
        @available_date     = Date.today.strftime("%F")

        @id_product_options = args[:id_product_options]
        @id_images          = args[:id_images]

        @id_lang            = args.fetch(:id_lang)
      end

      # ID of combination, or find ID by +reference+ and +id_product+
      def id
        @id ||= self.class.find_by 'filter[reference]' => reference, 'filter[id_product]' => id_product
      end
      alias :find? :id

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
        if id_product_options
          combination[:associations][:product_option_values] = {}
          combination[:associations][:product_option_values][:product_option_value] = hash_ids(id_product_options)
        end
        if id_images
          combination[:associations][:images] = {}
          combination[:associations][:images][:image] = hash_ids(id_images)
        end
        combination
      end

      def update options = {}
        self.class.update(id, options)
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