using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Product < Model
      resource :products
      model    :product

      attr_reader :id_shop_default, :id_supplier, :vat, :on_sale, :online_only, :ean, :upc, :ecotax, :minimal_quantity, 
                  :original_price, :wholesale_price, :out_of_stock, :condition, :quantity, :categories, :images, :manufacturer, :features, :combinations

      def initialize args = {}
        @id_shop_default    = 1
        @id_supplier        = settings.id_supplier
        
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
        @available_now      = args.fetch(:available_now, settings.available_now)
        @available_later    = args.fetch(:available_later, settings.available_later)
        
        # Dependencies
        @categories         = args[:category] || args[:categories]
        @images             = args[:image] || args[:images]
        @manufacturer       = args[:manufacturer]
        @features           = args[:feature] || args[:features]
        @combinations       = args[:combination] || args[:combinations]
      end

      def id_manufacturer
        Manufacturer.resolver @manufacturer
      end

      def id_features
        ProductFeature.resolver @features
      end

      # We call this method more than once, that's good idea to cache it
      def category
        @category ||= Category.resolver(@categories)
      end

      def name
        @name.plain.truncate(125)
      end

      def description
        @description.html if @description
      end

      def description_short
        @description_short ? @description_short.restricted.truncate(252) : (description.truncate(252) if description)
      end

      def link_rewrite
        @link_rewrite ? @link_rewrite.parameterize : name.parameterize
      end

      def id_tax_rules_group
        settings.taxes[vat.to_s]
      end

      def price
        @original_price ? Helper.calculate_price(@original_price, vat) : 0
      end

      def reference
        @reference ? @reference : name.parameterize
      end

      def active
        settings.product_active ? 1 : 0
      end

      def available_for_order
        settings.product_available_for_order ? 1 : 0
      end

      def show_price
        settings.product_show_price ? 1 : 0
      end

      def available_now
        @available_now ? @available_now.plain.truncate(125) : settings.available_now
      end

      def available_later
        @available_later ? @available_later.plain.truncate(125) : settings.available_later
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
          name:                 lang(name),
          description:          lang(description),
          description_short:    lang(description_short),
          link_rewrite:         lang(link_rewrite),
          meta_title:           lang(meta_title),
          meta_description:     lang(meta_description),
          meta_keywords:        lang(meta_keywords),
          available_now:        lang(available_now),
          available_later:      lang(available_later),
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

      # Generate hash with ID
      def hash_id id
        { id: id } if id
      end

      # Make array of unique IDs in hash
      def hash_ids ids
        ids.flatten.uniq.map{|id| hash_id(id)} if ids
      end

      # Generate hash of single feature
      def feature_hash hash
        { id: hash[:id_feature],
          id_feature_value: hash[:id_feature_value]
        } if hash
      end

      # Generate hash of features
      def features_hash
        id_features.map{|f| feature_hash(f)} if id_features
      end


      def create_or_update
        if reference
          current_products = Product.where 'filter[reference]' => reference, 'filter[id_supplier]' => id_supplier
          if current_products 
            current_products.map{|id| update(id)} if settings.update_enabled
          else
            create if settings.import_enabled
          end
        end
      end

      def create
        product = super
        if product
          sa = product[:associations][:stock_availables][:stock_available][:id]
          StockAvailable.update(sa, { quantity: quantity }) if quantity
          Image.upload(resource: :products, id: product[:id], file: images) if images
          Combination.resolve product[:id], combinations, price if combinations
        end
        product
      end

      def update id
        options = {}
        options[:price] = price if settings.update_price
        options[:id_tax_rules_group] = id_tax_rules_group if settings.vat_enabled

        product = Product.update(id, options)

        if product
          sa = StockAvailable.find_by 'filter[id_product]' => product[:id], 'filter[id_product_attribute]' => 0
          StockAvailable.update(sa, quantity: quantity, id_shop: id_shop_default) if settings.update_stock
          Combination.resolve product[:id], combinations, price if combinations and settings.update_enabled
        end
        product
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

        def deactivate
          if settings.deactivate and settings.update_enabled
            first = (Date.today-365).strftime("%F")
            last = (Date.today-1).strftime("%F")
            products = where 'filter[date_upd]' => "[#{first},#{last}]", date: 1, 'filter[id_supplier]' => settings.id_supplier, 'filter[active]' => 1, limit: 1000
            if products and !products.empty?
              products.map{|p| update(p, active: 0)}
            end
          end
          Combination.deactivate
        end
      end
    end
  end
end