require_relative 'test_helper'

module Prestashop
  module Mapper
    describe Combination do
      let(:category) { Category.new(attributes_for(:category)) }
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
    end
  end
end