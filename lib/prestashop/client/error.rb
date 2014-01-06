module Prestashop
  module Client
    class UnitializedClient < RuntimeError
      def initialize
        super "Client isn't initialized"
      end
    end
  end
end