require_relative 'test_helper'

module Prestashop
  module Api
    describe Connection do
      let(:connection)    { Connection.new '123', 'http://localhost.com' }

      it "should test connection" do
        stub_request(:get, 'http://123:@localhost.com/api')
        connection.test_connection.must_equal true
      end

      it "should head" do
        stub_request(:head, 'http://123:@localhost.com/api/users')
        connection.head resource: :users
      end

      it "should delete" do
        stub_request(:delete, 'http://123:@localhost.com/api/users/1')
        connection.delete resource: :users, id: 1
      end

      describe 'with xml expecting' do 
        before              { Converter.expects(:from_xml) }

        it "should get" do
          stub_request(:get, 'http://123:@localhost.com/api/users')
          connection.get resource: :users
        end

        it "should get with id" do
          stub_request(:get, 'http://123:@localhost.com/api/users/1')
          connection.get resource: :users, id: 1
        end

        it "should get with multiple ids" do
          stub_request(:get, 'http://123:@localhost.com/api/users?id=[1,2,3]')
          connection.get resource: :users, id: [1, 2, 3]
        end

        it "should post" do
          stub_request(:post, 'http://123:@localhost.com/api/users/1')
          connection.create resource: :users, model: :user, id: 1, payload: { name: 'Steve' }
        end

        it "should put" do
          stub_request(:put, 'http://123:@localhost.com/api/users/1')
          connection.update resource: :users, model: :user, id: 1, payload: { name: 'Steve' }
        end

        # it "should upload" do
        #   stub_request(:put, 'http://123:@localhost.com/api/users/1')
        #   connection.upload resource: :users, model: :user, id: 1, file: 'steve.jpg'
        # end
      end
    end
  end
end