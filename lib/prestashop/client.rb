require 'prestashop/client/error'
require 'prestashop/client/implementation'
require 'prestashop/client/settings'

module Prestashop
  module Client
    extend SingleForwardable
    def_delegators :current, :connection, :settings
    def_delegators :connection, :create, :read, :update, :delete, :check, :upload
    def_delegators :settings, :country_iso_code, :lang_iso_code, :import_enabled, :update_enabled, :update_price, :update_stock,
      :deactivate, :product_active, :product_available_for_order, :product_show_price, :vat_enabled, :available_now, :available_later,
      :delimiter, :html_enabled, :id_country, :id_language, :id_supplier, :taxes, :manufacturers_cache, :clear_manufacturers_cache,
      :categories_cache, :clear_categories_cache, :features_cache, :clear_features_cache, :feature_values_cache, :clear_feature_values_cache,
      :options_cache, :clear_options_cache, :option_values_cache, :clear_option_values_cache
    
    # Delegate to current user implementation
    def self.current
      Implementation.current
    end
  end
end