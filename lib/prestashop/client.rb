require 'prestashop/client/error'
require 'prestashop/client/implementation'
require 'prestashop/client/cache'

module Prestashop
  module Client
    extend SingleForwardable
    def_delegators  :current, :connection, :cache
    def_delegators  :connection, :create, :read, :update, :delete, :check, :upload
    def_delegators  :cache, :manufacturers_cache, :clear_manufacturers_cache, :categories_cache, :clear_categories_cache, :features_cache, :clear_features_cache, 
                    :feature_values_cache, :clear_feature_values_cache, :options_cache, :clear_options_cache, :option_values_cache, :clear_option_values_cache
    
    # Delegate to current user implementation
    # 
    def self.current
      Implementation.current
    end
  end
end