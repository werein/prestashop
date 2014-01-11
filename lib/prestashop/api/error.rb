module Prestashop
  module Api
    class InvalidCredentials < RuntimeError #:nodoc:
      def initialize
        super "Your credentials are invalid" 
      end
    end

    class RequestFailed < RuntimeError #:nodoc:
      attr_reader :response
      def initialize response
        @response = response
      end
    end
  end
end