require_relative 'test_helper'

module Prestashop
  module Mapper
    describe ProductOptionValue do
      let(:option_value) { ProductOptionValue.new(attributes_for(:product_option_value)) }
      before do 
        xml = <<-EOT
        <?xml version="1.0" encoding="UTF-8"?>
        <prestashop xmlns:xlink="http://www.w3.org/1999/xlink">
          <product_option_values>
            <product_option_value>
              <id><![CDATA[1]]></id>
              <id_attribute_group xlink:href="http://dev.demo.storio.cz/api/product_options/1"><![CDATA[1]]></id_attribute_group>
              <color><![CDATA[0]]></color>
              <position><![CDATA[0]]></position>
              <name><language id="2" xlink:href="http://dev.demo.storio.cz/api/languages/2"><![CDATA[16GB]]></language></name>
            </product_option_value>
            <product_option_value>
              <id><![CDATA[2]]></id>
              <id_attribute_group xlink:href="http://dev.demo.storio.cz/api/product_options/1"><![CDATA[2]]></id_attribute_group>
              <color><![CDATA[0]]></color>
              <position><![CDATA[1]]></position>
              <name><language id="2" xlink:href="http://dev.demo.storio.cz/api/languages/2"><![CDATA[White]]></language></name>
            </product_option_value>
          </product_option_values>
        </prestashop>
        EOT
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

      it "should find in cache" do 
        cache = [ { name: { language: { val: '16GB',  attr: { id: 2 }}},  id_attribute_group: 1,  id: 1},
                  { name: { language: { val: 'White',  attr: { id: 2 }}},  id_attribute_group: 2,  id: 2} ]
        Client.stubs(:option_values_cache).returns(cache)
        ProductOptionValue.find_in_cache(2, 'White', 2).must_equal(cache[1])
      end

      it "should generate cache" do
        ProductOptionValue.expects(:all).with(display: '[id,id_attribute_group,name]')
        ProductOptionValue.cache
      end
    end 
  end
end
