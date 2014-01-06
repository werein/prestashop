module Prestashop
  module Api
    class InvalidCredentials < RuntimeError
      def initialize
        super "Some configuration is invalid" 
      end
    end
  end
end