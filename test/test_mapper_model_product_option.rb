require_relative 'test_helper'

module Prestashop
  module Mapper
    describe ProductOption do
      let(:option) { ProductOption.new(attributes_for(:product_option_basic)) }
      before do 
        xml = <<-EOT
        <?xml version="1.0" encoding="UTF-8"?>
        <prestashop xmlns:xlink="http://www.w3.org/1999/xlink">
          <product_options>
            <product_option>
              <id><![CDATA[1]]></id>
              <is_color_group><![CDATA[0]]></is_color_group>
              <group_type><![CDATA[select]]></group_type>
              <position><![CDATA[0]]></position>
              <name><language id="2" xlink:href="http://dev.demo.storio.cz/api/languages/2"><![CDATA[Capacity]]></language></name>
              <public_name><language id="2" xlink:href="http://dev.demo.storio.cz/api/languages/2"><![CDATA[Capacity]]></language></public_name>
            <associations>
              <product_option_values node_type="product_option_value">
                <product_option_value xlink:href="http://dev.demo.storio.cz/api/product_option_values/1">
                  <id><![CDATA[1]]></id>
                </product_option_value>
              </product_option_values>
            </associations>
          </product_options>
        </prestashop>
        EOT
      end

      it "must have valid hash" do
        result = { is_color_group: 0,  position: nil,  group_type: "select",  name: { language: { val: "Capacity",  attr: { id: 2}}},  public_name: { language: { val: "Capacity",  attr: { id: 2}}}}
        option.hash.must_equal result
      end

      it "must find from API" do 
        ProductOption.expects(:find_in_cache).returns({id: 1})
        option.find_or_create.must_equal 1
      end

      it "must create new one, when doesnt exist" do
        Client.stubs(:clear_options_cache).returns(true)
        ProductOption.expects(:find_in_cache).returns(false)
        option.stubs(:create).returns({id: 1})
        option.find_or_create.must_equal 1
      end

      it "should raise error" do 
        -> {  option.id_lang = '1'
              option.validate! }.must_raise ArgumentError        
        -> {  option.name = :apple
              option.validate! }.must_raise ArgumentError
        -> {  option.group_type = 1
              option.validate! }.must_raise ArgumentError
      end

      it "should find in cache" do 
        cache = [ { name: { language: { val: 'Capacity',  attr: { id: 2 }}}, id: 1},
                  { name: { language: { val: 'Color',  attr: { id: 2 }}}, id: 2} ]
        Client.stubs(:options_cache).returns(cache)
        ProductOption.find_in_cache('Capacity', 2).must_equal(cache[0])
      end

      it "should generate cache" do
        ProductOption.expects(:all).with(display: '[id,name]')
        ProductOption.cache
      end
    end 
  end
end
