require 'singleton'

module Prestashop
  module Client
    class Implementation
      include Singleton
      attr_reader :connection, :settings

      # Initialize new client
      #
      # ==== Parameters:
      # * +api_key+ - see #Api::Connection.new
      # * +api_url+ - see #Api::Connection.new
      # * +settings+ - see #Settings.new
      #
      def initialize api_key, api_url, options = {}
        @connection = Api::Connection.new api_key, api_url
        @settings = Settings.new options
      end

      class << self
        # Create new user implementation, keep it in current thread to allow multithearding, see (#new)
        def create api_key, api_url, options = {}
          Thread.current[:prestashop_client] = new api_key, api_url, options
          current
        end

        # Return current client or raise exception, when client isn't initialized
        def current
          Thread.current[:prestashop_client] ? Thread.current[:prestashop_client] : raise(UnitializedClient)
        end
      end
    end
  end
end