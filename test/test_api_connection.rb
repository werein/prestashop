require_relative 'test_helper'

module Prestashop
  module Api
    describe Connection do
      let(:response)      { "response" }

      describe "invalid connection" do 
        it "should not be created" do 
          stub_request(:get, 'http://123:@localhost.com/api/').to_return(status: [401, "Welcome to PrestaShop Webservice, please enter the authentication key as the login. No password required."])
          ->{ Connection.new '123', 'http://localhost.com' }.must_raise InvalidCredentials
        end
      end

      describe "valid connection" do 
        let(:connection)    { Connection.new '123', 'http://localhost.com' }
        before              { stub_request(:get, 'http://123:@localhost.com/api/') }

        it "should work" do 
          connection.test.must_equal true
        end

        it "should head" do
          stub_request(:head, 'http://123:@localhost.com/api/products')
          connection.head :products
        end

        it "should delete" do
          stub_request(:delete, 'http://123:@localhost.com/api/products/1')
          connection.delete :products, 1
        end

        describe 'with xml expecting' do 
          before { response.expects(:parse) }

          it "should get" do
            stub_request(:get, 'http://123:@localhost.com/api/products').to_return(body: response)
            connection.get :products
          end

          it "should get with id" do
            stub_request(:get, 'http://123:@localhost.com/api/products/1').to_return(body: response)
            connection.get :products, 1
          end

          it "should get with multiple ids" do
            stub_request(:get, 'http://123:@localhost.com/api/products?id=[1,2,3]').to_return(body: response)
            connection.get :products, [1, 2, 3]
          end

          it "should post" do
            stub_request(:post, 'http://123:@localhost.com/api/products').to_return(body: response)
            connection.create :products, {}
          end

          it "should put" do
            stub_request(:put, 'http://123:@localhost.com/api/products/1').to_return(body: response)
            connection.update :products, 1, {}
          end

          it "should upload" do
            file = mock('file')
            file.expects(:destroy!)
            stub_request(:post, 'http://123:@localhost.com/api/images/products/1').to_return(body: response)
            connection.upload :images, :products, 1, {}, file
          end
        end
      end

      describe "error expecting" do
        let(:connection)    { Connection.new '123', 'http://localhost.com' }
        before do 
          stub_request(:get, 'http://123:@localhost.com/api/')
          response.expects(:parse_error)
        end

        it "should raise error " do
          stub_request(:get, 'http://123:@localhost.com/api/products').to_return(status: [400], body: response)
          ->{ connection.get :products }.must_raise RequestFailed    
        end
      end
    end
  end
end