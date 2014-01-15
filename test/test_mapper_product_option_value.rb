require_relative 'test_helper'

module Prestashop
  module Mapper
    describe ProductOptionValue do
      let(:option_value) { ProductOptionValue.new(attributes_for(:product_option_value)) }
      before do 
        Client.stubs(:id_language).returns(2)
      end

      it "must have valid hash" do
        result = { name: { language: { val: '16GB',  attr: { id: 2 }}},  id_attribute_group: 1,  color: 0}
        option_value.hash.must_equal result
      end

      it "must find from API" do 
        ProductOptionValue.expects(:find_in_cache).returns({id: 1})
        option_value.find_or_create.must_equal 1
      end

      it "must create new one, when doesnt exist" do
        Client.stubs(:clear_option_values_cache).returns(true)
        ProductOptionValue.expects(:find_in_cache).returns(false)
        option_value.stubs(:create).returns({id: 1})
        option_value.find_or_create.must_equal 1
      end

      it "should raise error" do 
        -> {  option_value.id_lang = '1'
              option_value.validate! }.must_raise ArgumentError        
        -> {  option_value.name = :apple
              option_value.validate! }.must_raise ArgumentError
        -> {  option_value.id_attribute_group = 'a'
              option_value.validate! }.must_raise ArgumentError
        -> {  option_value.color = 2
              option_value.validate! }.must_raise ArgumentError
      end
    end 
  end
end
