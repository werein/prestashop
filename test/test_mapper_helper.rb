require_relative 'test_helper'

module Prestashop
  module Mapper
    describe Helper do 

      it "should calculate price from number" do
        Helper.calculate_price(100, 20).must_equal 100
      end

      it "should calculate price from string" do
        Helper.calculate_price('100.00001', 20).must_equal 100
      end

      describe "vat enabled" do 
        before do 
          Client.stubs(:settings).returns({})
          Client.settings.stubs(:vat_enabled).returns(true)
        end

        it "should calculate from price with vat" do
          price = { price: 100 }
          Helper.calculate_price(price, 20).must_equal 100
        end

        it "should calculate price from configuration" do 
          price = { price: 110, config: { 
            adjustment: 'increase',
            adjustment_type: 'fee',
            adjustment_value: '10' } }

          Helper.calculate_price(price, 10).must_equal 120
        end

        it "should calculate price from configuration" do 
          price = { price: 110, config: { 
            adjustment: 'increase',
            adjustment_type: 'percentage',
            adjustment_value: '10' } }

          Helper.calculate_price(price, 10).must_equal 121
        end

        it "should calculate price from configuration" do 
          price = { price: 100, config: { 
            adjustment: 'none',
            adjustment_type: 'fee',
            adjustment_value: '30' } }

          Helper.calculate_price(price, 10).must_equal 100
        end
      end

      describe "vat disabled" do 
        before do 
          Client.stubs(:settings).returns({})
          Client.settings.stubs(:vat_enabled).returns(false)
        end

        it "should calculate from price without vat" do
          price = { price: 100 }
          Helper.calculate_price(price, 20).must_equal 120
        end

        it "should calculate price from configuration" do 
          price = { price: 110, config: { 
            adjustment: 'increase',
            adjustment_type: 'fee',
            adjustment_value: '10' } }

          Helper.calculate_price(price, 10).must_equal 131
        end

        it "should calculate price from configuration" do 
          price = { price: 110, config: { 
            adjustment: 'increase',
            adjustment_type: 'percentage',
            adjustment_value: '10' } }

          Helper.calculate_price(price, 10).must_equal 133.1
        end

        it "should calculate price from configuration" do 
          price = { price: 100, config: { 
            adjustment: 'increase',
            adjustment_type: 'none',
            adjustment_value: '30' } }

          Helper.calculate_price(price, 10).must_equal 110
        end
      end

      it "should calculate price" do 
        Helper.without_vat(120, 20).must_equal 100
        Helper.without_vat(110, 10).must_equal 100
      end
    end 
  end
end