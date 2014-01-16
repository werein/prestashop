require_relative 'test_helper'

module Prestashop
  module Mapper
    class Car
      include Extension
      extend Extension
    end

    describe Car do
      let(:car) { Car.new }
      before do
        Car.stubs(:resource).returns(:cars)
        Car.stubs(:model).returns(:car)
        stub_request(:get, 'http://123:@localhost.com/api/')
        connection = Api::Connection.new('123', 'localhost.com')
        Client.stubs(:connection).returns(connection)
      end
  
      it "should determinate if exist" do
        stub_request(:head, 'http://123:@localhost.com/api/cars/1')
        Car.exists?(1).must_equal true
      end      

      it "should determinate if can find" do
        body = <<-EOT
        <?xml version="1.0" encoding="UTF-8"?>
        <prestashop xmlns:xlink="http://www.w3.org/1999/xlink">
        <car>
          <id><![CDATA[1]]></id>
          <name><![CDATA[BMW]]></name>
        </car>
        </prestashop>
        EOT

        result = { id: 1, name: 'BMW' }
        stub_request(:get, 'http://123:@localhost.com/api/cars/1').to_return(body: body)
        Car.find(1).must_equal result
      end

      it "should get all" do 
        body = <<-EOT
        <?xml version="1.0" encoding="UTF-8"?>
        <prestashop xmlns:xlink="http://www.w3.org/1999/xlink">
          <cars>
            <car id="1" xlink:href="http://locahost.com/api/cars/1"/>
            <car id="2" xlink:href="http://locahost.com/api/cars/2"/>
            <car id="3" xlink:href="http://locahost.com/api/cars/3"/>
          </cars>
        </prestashop>
        EOT

        stub_request(:get, 'http://123:@localhost.com/api/cars').to_return(body: body)        
        Car.all.must_equal([1,2,3])
      end

      it "should get all with display option" do 
        body = <<-EOT
        <?xml version="1.0" encoding="UTF-8"?>
        <prestashop xmlns:xlink="http://www.w3.org/1999/xlink">
          <cars>
            <car>
              <id_supplier xlink:href="http://dev.demo.storio.cz/api/suppliers/1"><![CDATA[1]]></id_supplier>
              <name><language id="2" xlink:href="http://localhost.com/api/languages/2"><![CDATA[BMW 7]]></language></name>
            </car>
            <car>
              <id_supplier xlink:href="http://dev.demo.storio.cz/api/suppliers/1"><![CDATA[1]]></id_supplier>
              <name><language id="2" xlink:href="http://localhost.com/api/languages/2"><![CDATA[BMW 5]]></language></name>
            </car>
          </cars>
        </prestashop>
        EOT

        result = [ { 
            id_supplier: 1, 
            name: { language: { attr: { id: 2 }, val: 'BMW 7'}}
          }, { 
            id_supplier: 1, 
            name: { language: { attr: { id: 2 }, val: 'BMW 5'}}
          }
        ]

        stub_request(:get, 'http://123:@localhost.com/api/cars?display=%5Bid_supplier,name%5D').to_return(body: body)        
        Car.all(display: '[id_supplier,name]').must_equal(result)
      end

      it "should find by filter" do 
        body = <<-EOT
        <?xml version="1.0" encoding="UTF-8"?>
        <prestashop xmlns:xlink="http://www.w3.org/1999/xlink">
          <cars>
            <car id="1" xlink:href="http://locahost.com/api/cars/1"/>
            <car id="2" xlink:href="http://locahost.com/api/cars/2"/>
          </cars>
        </prestashop>
        EOT

        stub_request(:get, 'http://123:@localhost.com/api/cars?filter%5Bid_supplier%5D=1').to_return(body: body)        
        Car.where('filter[id_supplier]' => '1').must_equal([1,2])
      end

      it "should destroy by id" do 
        stub_request(:delete, 'http://123:@localhost.com/api/cars/1')
        Car.destroy(1).must_equal(true)
      end

      it "should generate upload hash" do 
        Car.stubs(:fixed_hash).returns({name: 'BMW 5', manufacturer: 'BMW'})
        Car.update_hash(1, name: 'BMW 7').must_equal({ name: 'BMW 7', manufacturer: 'BMW' })
      end

      it "should generate payload for upload" do
        result = '<prestashop xmlns:xlink="http://www.w3.org/1999/xlink"><car><name><![CDATA[Audi]]></name></car></prestashop>'
        Car.stubs(:update_hash).returns({name: 'Audi'})
        Car.update_payload(1, name: 'Audi').must_equal result
      end

      it "should update item" do 
        request = '<prestashop xmlns:xlink="http://www.w3.org/1999/xlink"><car><id><![CDATA[1]]></id><name><![CDATA[BMW]]></name></car></prestashop>'
        body = '<prestashop xmlns:xlink="http://www.w3.org/1999/xlink"><car><id><![CDATA[1]]></id><name><![CDATA[Audi]]></name></car></prestashop>'

        stub_request(:put, 'http://123:@localhost.com/api/cars/1').with(body: body).to_return(body: body)        
        stub_request(:get, 'http://123:@localhost.com/api/cars/1').to_return(body: request)        
        result = { id: 1, name: 'Audi' }
        Car.update(1, name: 'Audi').must_equal result
      end

      it "should generate id in hash" do 
        Car.new.hash_id(1).must_equal({id: 1})
      end

      it "should generate hash of ids" do 
        Car.new.hash_ids([1,2,3]).must_equal([{id: 1},{id: 2},{id: 3}])
      end

      it "should generate payload" do 
        car = Car.new
        car.stubs(:hash).returns({ name: 'BMW 7', manufacturer: 'BMW' })
        car.payload.must_equal '<prestashop xmlns:xlink="http://www.w3.org/1999/xlink"><car><name><![CDATA[BMW 7]]></name><manufacturer><![CDATA[BMW]]></manufacturer></car></prestashop>'
      end

      it "should create new object" do 
        hash = { name: 'BMW 7', manufacturer: 'BMW' }
        payload = '<prestashop xmlns:xlink="http://www.w3.org/1999/xlink"><car><name><![CDATA[BMW 7]]></name><manufacturer><![CDATA[BMW]]></manufacturer></car></prestashop>'
        result = '<prestashop xmlns:xlink="http://www.w3.org/1999/xlink"><car><id><![CDATA[1]]></id><name><![CDATA[BMW 7]]></name><manufacturer><![CDATA[BMW]]></manufacturer></car></prestashop>'
        stub_request(:post, 'http://123:@localhost.com/api/cars').with(body: payload).to_return(body: result)        

        car = Car.new
        car.stubs(:hash).returns(hash)
        car.create.must_equal(hash.merge(id: 1))
      end
    end 
  end
end
