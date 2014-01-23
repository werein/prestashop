require_relative 'test_helper'

module Prestashop
  module Mapper
    describe Combination do
      let(:combination) { Combination.new(attributes_for(:combination_basic)) }
      before do
        xml = <<-EOF
        <?xml version="1.0" encoding="UTF-8"?>
        <prestashop xmlns:xlink="http://www.w3.org/1999/xlink">
          <combination>
            <id><![CDATA[1]]></id>
            <id_product xlink:href="http://localhost.com/api/products/2"><![CDATA[2]]></id_product>
            <location></location>
            <ean13></ean13>
            <upc></upc>
            <quantity><![CDATA[10]]></quantity>
            <reference></reference>
            <supplier_reference></supplier_reference>
            <wholesale_price><![CDATA[0.000000]]></wholesale_price>
            <price><![CDATA[0.000000]]></price>
            <ecotax><![CDATA[0.000000]]></ecotax>
            <weight><![CDATA[0.000000]]></weight>
            <unit_price_impact><![CDATA[0.00]]></unit_price_impact>
            <minimal_quantity><![CDATA[1]]></minimal_quantity>
            <default_on><![CDATA[0]]></default_on>
            <available_date><![CDATA[0000-00-00]]></available_date>
          <associations>
            <product_option_values node_type="product_option_value">
              <product_option_value xlink:href="http://localhost.com/api/product_option_values/4">
              <id><![CDATA[4]]></id>
              </product_option_value>
            </product_option_values>
            <images node_type="image">
              <image xlink:href="http://localhost.com/api/images/combinations/1/23">
              <id><![CDATA[23]]></id>
              </image>
            </images>
          </associations>
          </combination>
        </prestashop>
        EOF
      end

      it "should look for id, when doesnt exist" do
        Combination.expects(:find_by).returns(false)
        combination.find?.must_equal false
        Combination.expects(:find_by).returns(1)
        combination.id.must_equal 1
        combination.id = 2
        combination.id.must_equal(2)
      end

      it "should update model" do 
        Combination.expects(:update).with(1, quantity: 100)
        combination.stubs(:id).returns(1)
        combination.update(quantity: 100)
      end
    end
  end
end