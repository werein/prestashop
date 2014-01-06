require 'forwardable'
require 'prestashop/client/errors'
require 'prestashop/client/implementation'
require 'prestashop/client/settings'

module Prestashop
  module Client
    extend SingleForwardable
    def_delegators :current, :connection, :settings

    def self.current
      Implementation.current
    end
  end
end