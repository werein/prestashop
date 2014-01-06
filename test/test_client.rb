require_relative 'test_helper'

module Prestashop
  module Client
    describe Client do

      it "should be forwardable to Implementation" do
        Implementation.expects(:current)
        Client.current
      end

      it "should forward connection and settings" do
        client = mock 'client'
        client.expects(:connection)
        client.expects(:settings)
        Implementation.stubs(:current).returns(client)
        Client.connection
        Client.settings
      end
    end
  end
end