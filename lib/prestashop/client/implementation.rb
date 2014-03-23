require 'singleton'

module Prestashop
  module Client
    class Implementation
      include Singleton
      attr_reader :connection, :cache

      # Initialize new client see +Api::Connection#new+
      #
      def initialize api_key, api_url
        @connection = Api::Connection.new api_key, api_url
        @cache = Cache.new
      end

      class << self

        # Create new user implementation, keep it in current thread to allow multithearding, see +#new+
        #
        def create api_key, api_url
          Thread.current[:prestashop_client] = new api_key, api_url
          current
        end

        # Get current client or raise exception, when client isn't initialized
        #
        def current
          Thread.current[:prestashop_client] ? Thread.current[:prestashop_client] : raise(UnitializedClient)
        end
      end
    end
  end
end