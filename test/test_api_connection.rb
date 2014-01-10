require_relative 'test_helper'

module Prestashop
  module Api
    describe Connection do
      let(:response)      { mock('response') }

      describe "invalid connection" do 
        it "should not be created" do 
          stub_request(:get, 'http://123:@localhost.com/api').to_return(status: [401, "Welcome to PrestaShop Webservice, please enter the authentication key as the login. No password required."])
          ->{ Connection.new '123', 'http://localhost.com' }.must_raise InvalidCredentials
        end
      end

      describe "valid connection" do 
        let(:connection)    { Connection.new '123', 'http://localhost.com' }
        before              { stub_request(:get, 'http://123:@localhost.com/api') }

        it "should work" do 
          connection.test.must_equal true
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
          before { response.expects(:parse) }

          it "should get" do
            stub_request(:get, 'http://123:@localhost.com/api/users').to_return(body: response)
            connection.get resource: :users
          end

          it "should get with id" do
            stub_request(:get, 'http://123:@localhost.com/api/users/1').to_return(body: response)
            connection.get resource: :users, id: 1
          end

          it "should get with multiple ids" do
            stub_request(:get, 'http://123:@localhost.com/api/users?id=[1,2,3]').to_return(body: response)
            connection.get resource: :users, id: [1, 2, 3]
          end

          it "should post" do
            stub_request(:post, 'http://123:@localhost.com/api/users/1').to_return(body: response)
            connection.create resource: :users, model: :user, id: 1, payload: { name: 'Steve' }
          end

          it "should put" do
            stub_request(:put, 'http://123:@localhost.com/api/users/1').to_return(body: response)
            connection.update resource: :users, model: :user, id: 1, payload: { name: 'Steve' }
          end

          # it "should upload" do
          #   stub_request(:post, 'http://123:@localhost.com/api/image/users/1').to_return(body: response)
          #   connection.upload resource: :users, model: :user, type: :image, id: 1, file: 'steve.jpg'
          # end
        end
      end

      describe "error expecting" do
        let(:connection)    { Connection.new '123', 'http://localhost.com' }
        before do 
          stub_request(:get, 'http://123:@localhost.com/api')
          response.expects(:parse_error)
        end

        it "should raise error " do
          stub_request(:get, 'http://123:@localhost.com/api/users').to_return(status: [400], body: response)
          ->{ connection.get resource: :users }.must_raise RequestFailed    
        end
      end
    end
  end
end