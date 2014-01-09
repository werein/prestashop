module Prestashop
  module Client
    class UnitializedClient < RuntimeError #:nodoc:
      def initialize
        super "Client isn't initialized"
      end
    end
  end
end