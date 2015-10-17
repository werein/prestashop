using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Product < Model
      resource :products
      model    :product

      attr_accessor :id_manufacturer, :id_supplier, :id_category_default, :new, :cache_default_attribute, :id_tax_rules_group, :position_in_category,
                    :manufacturer_name, :quantity, :type, :id_shop_default, :supplier_reference, :location, :width, :height, :depth,
                    :weight, :quantity_discount, :ean13, :upc, :cache_is_pack, :cache_has_attachment, :is_virtual, :on_sale, :online_only, :ecotax, :minimal_quantity,
                    :price, :wholesale_price, :unity, :unit_price_ratio, :additional_shipping_cost, :customizable, :text_fields, :uploadable_files, :active,
                    :redirect_type, :id_product_redirect, :available_for_order, :available_date, :condition, :show_price, :indexed, :visibility, :advanced_stock_management, :description
      attr_accessor :id_lang, :id_categories, :id_features
      attr_writer   :id, :name, :description_short, :link_rewrite, :reference, :price, :available_now, :available_later, :meta_description, :meta_keywords, :meta_title

      def initialize args = {}
        @id                         = args[:id]
        @id_manufacturer            = args[:id_manufacturer]
        @id_supplier                = args.fetch(:id_supplier)
        @id_category_default        = args[:id_category_default]
        @new                        = args[:new]
        @cache_default_attribute    = args.fetch(:cache_default_attribute, 0)
        @id_tax_rules_group         = args[:id_tax_rules_group]
        @position_in_category       = args.fetch(:position_in_category, 0)
        @manufacturer_name          = args[:manufacturer_name]
        @quantity                   = args[:quantity]
        @type                       = args.fetch(:type, 'simple')
        @id_shop_default            = args.fetch(:id_shop_default, 1)
        @reference                  = args.fetch(:reference)
        @supplier_reference         = args[:supplier_reference]
        @location                   = args[:location]
        @width                      = args[:width]
        @height                     = args[:height]
        @depth                      = args[:depth]
        @weight                     = args[:weight]
        @quantity_discount          = args.fetch(:quantity_discount, 0)
        @ean13                      = args[:ean13]
        @upc                        = args[:upc]
        @cache_is_pack              = args.fetch(:cache_is_pack, 0)
        @cache_has_attachment       = args.fetch(:cache_has_attachment, 0)
        @is_virtual                 = args.fetch(:is_virtual, 0)
        @on_sale                    = args.fetch(:on_sale, 0)
        @online_only                = args.fetch(:online_only, 0)
        @ecotax                     = args.fetch(:ecotax, 0)
        @minimal_quantity           = args.fetch(:minimal_quantity, 1)
        @price                      = args[:price]
        @wholesale_price            = args[:wholesale_price]
        @unity                      = args[:unity]
        @unit_price_ratio           = args[:unit_price_ratio]
        @additional_shipping_cost   = args[:additional_shipping_cost]
        @customizable               = args[:customizable]
        @text_fields                = args[:text_fields]
        @uploadable_files           = args[:uploadable_files]
        @active                     = args[:active]
        @redirect_type              = args[:redirect_type]
        @id_product_redirect        = args[:id_product_redirect]
        @available_for_order        = args[:available_for_order]
        @available_date             = args.fetch(:available_date, Date.today.strftime("%F"))
        @condition                  = args.fetch(:condition, 'new')
        @show_price                 = args[:show_price]
        @indexed                    = 0
        @visibility                 = args.fetch(:visibility, 'both')
        @advanced_stock_management  = args[:advanced_stock_management]
        # date_add
        # date_upd
        @meta_description           = args[:meta_description]
        @meta_keywords              = args[:meta_keywords]
        @meta_title                 = args[:meta_title]
        @link_rewrite               = args[:link_rewrite]
        @name                       = args.fetch(:name)
        @description                = args[:description]
        @description_short          = args[:description_short]
        @available_now              = args[:available_now]
        @available_later            = args[:available_later]

        @id_lang                    = args.fetch(:id_lang)
        @id_categories              = args[:id_categories]
        @id_features                = args[:id_features]
      end

      def name
        @name.plain.truncate(125)
      end

      def description_short
        @description_short ? @description_short.restricted.truncate(252) : (description.truncate(252) if description)
      end

      def link_rewrite
        @link_rewrite ? @link_rewrite.parameterize : name.parameterize
      end

      def reference
        if @reference and not @reference.to_s.empty?
          @reference.to_s.length > 32 ? Digest::MD5.hexdigest(@reference) : @reference
        else
          Digest::MD5.hexdigest(name)
        end
      end

      def available_now
        @available_now.plain.truncate(125)
      end

      def available_later
        @available_later.plain.truncate(125)
      end

      def hash
        product = {
          id_supplier:          id_supplier,
          id_manufacturer:      id_manufacturer,
          id_category_default:  id_category_default,
          id_shop_default:      id_shop_default,
          id_tax_rules_group:   id_tax_rules_group,
          on_sale:              on_sale,
          online_only:          online_only,
          ean13:                ean13,
          upc:                  upc,
          ecotax:               ecotax,
          minimal_quantity:     minimal_quantity,
          price:                price,
          wholesale_price:      wholesale_price,
          reference:            reference,
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
        unless id_categories_all.empty?
          product[:associations][:categories] = {}
          product[:associations][:categories][:category] = hash_ids(id_categories_all)
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

      def id_categories_all
        [id_category_default, id_categories].flatten.uniq
      end

      class << self
        def fixed_hash id
          product = find id
          product.delete(:position_in_category)
          product.delete(:manufacturer_name)
          product.delete(:quantity)
          product.delete(:type)
          product.delete(:associations)
          product.delete(:id_default_image)
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
