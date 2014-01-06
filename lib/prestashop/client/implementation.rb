require 'singleton'

module Prestashop
  module Client
    class Implementation
      include Singleton
      attr_reader :connection, :settings

      def initialize api_key, api_url, options = {}
        @connection = Api::Connection.new api_key, api_url
        @settings = Settings.new options
      end

      class << self
        def create api_key, api_url, options = {}
          Thread.current[:prestashop_client] = new api_key, api_url, options
          current
        end

        def current
          Thread.current[:prestashop_client] ? Thread.current[:prestashop_client] : raise(UnitializedClient)
        end
      end
    end
  end
end