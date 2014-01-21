using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Product < Model
      resource :products
      model    :product

      attr_accessor :id_lang, :id_shop_default, :id_supplier, :vat, :on_sale, :online_only, :ean, :upc, :ecotax, :minimal_quantity, 
                  :original_price, :wholesale_price, :out_of_stock, :condition, :quantity, :categories, :images, :manufacturer, :features, :combinations
      attr_writer :name, :reference


      def initialize args = {}
        @id_lang            = args.fetch(:id_lang, Client.id_language)
        @id_shop_default    = 1
        @id_supplier        = Client.id_supplier
        
        @name               = args.fetch(:name)
        @description        = args[:description]
        @description_short  = args[:description_short]
        @link_rewrite       = args[:link_rewrite]
        @meta_title         = args[:meta_title]
        @meta_description   = args[:meta_description]
        @meta_keywords      = args[:meta_keywords]
        @vat                = args.fetch(:vat, 0).to_i
        @on_sale            = args.fetch(:on_sale, 0).to_i
        @online_only        = args.fetch(:online_only, 0).to_i
        @ean                = args[:ean]
        @upc                = args[:upc]
        @ecotax             = args.fetch(:ecotax, 0).to_f
        @minimal_quantity   = args.fetch(:minimal_quantity, 1).to_i
        @original_price     = args[:price]
        @quantity           = args.fetch(:quantity, 0).to_i
        @wholesale_price    = args.fetch(:wholesale_price, 0).to_f
        @reference          = args[:reference]
        @out_of_stock       = 2
        @condition          = args.fetch(:condition, 'new')
        @available_now      = args.fetch(:available_now, Client.available_now)
        @available_later    = args.fetch(:available_later, Client.available_later)
        
        # Dependencies
        @categories         = args[:category] || args[:categories]
        @images             = args[:image] || args[:images]
        @manufacturer       = args[:manufacturer]
        @features           = args[:feature] || args[:features]
        @combinations       = args[:combination] || args[:combinations]
      end

      # Get id manufacturer, see #Manufacturer.resolver for params and returns
      def id_manufacturer
        @id_manufacturer ||= Manufacturer.resolver(@manufacturer)
      end

      # Get id features, see #ProductFeature.resolver for params and returns
      def id_features
        @id_features ||= ProductFeature.resolver(@features)
      end

      # Get category, see #Category.resolver for params and returns
      def category
        @category ||= Category.resolver(@categories)
      end

      def name
        @name.plain.truncate(125)
      end

      def description
        @description.html(Client.html_enabled) if @description
      end

      def description_short
        @description_short ? @description_short.restricted.truncate(252) : (description.truncate(252) if description)
      end

      def link_rewrite
        @link_rewrite ? @link_rewrite.parameterize : name.parameterize
      end

      def id_tax_rules_group
        Client.taxes[vat.to_s]
      end

      def price
        @original_price ? Helper.calculate_price(@original_price, vat) : 0
      end

      def reference
        if @reference and not @reference.to_s.empty?
          @reference.to_s.length > 32 ? Digest::MD5.hexdigest(@reference) : @reference
        else
          Digest::MD5.hexdigest(name)
        end
      end

      def active
        Client.product_active ? 1 : 0
      end

      def available_for_order
        Client.product_available_for_order ? 1 : 0
      end

      def show_price
        Client.product_show_price ? 1 : 0
      end

      def available_now
        @available_now ? @available_now.plain.truncate(125) : Client.available_now
      end

      def available_later
        @available_later ? @available_later.plain.truncate(125) : Client.available_later
      end

      def hash
        product = { 
          id_supplier:          id_supplier,
          id_manufacturer:      id_manufacturer,
          id_category_default:  category[:id_category_default],
          id_shop_default:      id_shop_default,
          id_tax_rules_group:   id_tax_rules_group,
          on_sale:              on_sale,
          online_only:          online_only,
          ean13:                ean,
          upc:                  upc,
          ecotax:               ecotax,
          minimal_quantity:     minimal_quantity,
          price:                price,
          wholesale_price:      wholesale_price,
          reference:            reference,
          out_of_stock:         out_of_stock,
          active:               active,
          redirect_type:        '404',
          available_for_order:  available_for_order,
          condition:            condition,
          show_price:           show_price,
          name:                 hash_lang(name, id_lang),
          description:          hash_lang(description, id_lang),
          description_short:    hash_lang(description_short, id_lang),
          link_rewrite:         hash_lang(link_rewrite, id_lang),
          meta_title:           hash_lang(meta_title, id_lang),
          meta_description:     hash_lang(meta_description, id_lang),
          meta_keywords:        hash_lang(meta_keywords, id_lang),
          available_now:        hash_lang(available_now, id_lang),
          available_later:      hash_lang(available_later, id_lang),
          associations: {} }
        if category[:ids_category]
          product[:associations][:categories] = {}
          product[:associations][:categories][:category] = hash_ids(category[:ids_category])
        end
        if features_hash
          product[:associations][:product_features] = {}
          product[:associations][:product_features][:product_feature] = features_hash
        end
        product
      end

      # Find product by +reference+ and +id_supplier+, returns +id+
      def id
        @id ||= self.class.find_by 'filter[reference]' => reference, 'filter[id_supplier]' => id_supplier
      end
      alias :find? :id

      # Create new product with quantity
      def create
        response = super
        if response
          sa_id = response[:associations][:stock_availables][:stock_available][:id]
          StockAvailable.new(id: sa_id).update(quantity: quantity)
        end
        response
      end

      # Update product with given options
      def update options = {}
        self.class.update(id, options)
      end

      # Generate hash of single feature
      def feature_hash id_feature, id_feature_value
        { id: id_feature, id_feature_value: id_feature_value } if id_feature and id_feature_value
      end

      # Generate hash of features
      def features_hash
        id_features.map{|f| feature_hash(f[:id_feature], f[:id_feature_value])} if id_features
      end

      class << self
        def fixed_hash id
          product = find id
          product.delete(:position_in_category)
          product.delete(:manufacturer_name)
          product.delete(:quantity)
          product.delete(:type)
          product.delete(:associations)
          product
        end

        def deactivate id_supplier
          first = (Date.today-365).strftime("%F")
          last = (Date.today-1).strftime("%F")
          products = where 'filter[date_upd]' => "[#{first},#{last}]", date: 1, 'filter[id_supplier]' => id_supplier, 'filter[active]' => 1, limit: 1000
          if products and !products.empty?
            products.map{|p| update(p, active: 0)}
          end
        end
      end
    end
  end
end