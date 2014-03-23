module Prestashop
  module Api
    class InvalidCredentials < RuntimeError
      def initialize 
        super "Your credentials are invalid" 
      end
    end

    class RequestFailed < RuntimeError
      attr_reader :response
      def initialize response
        @response = response
      end
    end

    class ParserError < RuntimeError; end
  end
end