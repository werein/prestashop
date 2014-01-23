require_relative 'test_helper'

module Prestashop
  module Mapper
    describe Product do
      let(:product) { Product.new(attributes_for(:product)) }
      before do
        xml = <<-EOF
        <?xml version="1.0" encoding="UTF-8"?>
        <prestashop xmlns:xlink="http://www.w3.org/1999/xlink">
          <product>
            <id><![CDATA[1]]></id>
            <id_manufacturer xlink:href="http://localhost.com/api/manufacturers/1"><![CDATA[1]]></id_manufacturer>
            <id_supplier xlink:href="http://localhost.com/api/suppliers/1"><![CDATA[1]]></id_supplier>
            <id_category_default xlink:href="http://localhost.com/api/categories/3"><![CDATA[3]]></id_category_default>
            <new></new>
            <cache_default_attribute><![CDATA[0]]></cache_default_attribute>
            <id_default_image xlink:href="http://localhost.com/api/images/products/1/15" not_filterable="true"><![CDATA[15]]></id_default_image>
            <id_default_combination xlink:href="http://localhost.com/api/combinations/18" not_filterable="true"><![CDATA[18]]></id_default_combination>
            <id_tax_rules_group xlink:href="http://localhost.com/api/tax_rule_groups/1"><![CDATA[1]]></id_tax_rules_group>
            <position_in_category not_filterable="true"><![CDATA[0]]></position_in_category>
            <manufacturer_name not_filterable="true"><![CDATA[Apple Computer, Inc]]></manufacturer_name>
            <quantity not_filterable="true"><![CDATA[0]]></quantity>
            <type not_filterable="true"><![CDATA[simple]]></type>
            <id_shop_default><![CDATA[1]]></id_shop_default>
            <reference><![CDATA[demo_1]]></reference>
            <supplier_reference></supplier_reference>
            <location></location>
            <width><![CDATA[0.000000]]></width>
            <height><![CDATA[0.000000]]></height>
            <depth><![CDATA[0.000000]]></depth>
            <weight><![CDATA[0.500000]]></weight>
            <quantity_discount><![CDATA[0]]></quantity_discount>
            <ean13><![CDATA[0]]></ean13>
            <upc></upc>
            <cache_is_pack><![CDATA[0]]></cache_is_pack>
            <cache_has_attachments><![CDATA[0]]></cache_has_attachments>
            <is_virtual><![CDATA[0]]></is_virtual>
            <on_sale><![CDATA[0]]></on_sale>
            <online_only><![CDATA[0]]></online_only>
            <ecotax><![CDATA[0.000000]]></ecotax>
            <minimal_quantity><![CDATA[1]]></minimal_quantity>
            <price><![CDATA[191.26]]></price>
            <wholesale_price><![CDATA[70.000000]]></wholesale_price>
            <unity></unity>
            <unit_price_ratio><![CDATA[0.000000]]></unit_price_ratio>
            <additional_shipping_cost><![CDATA[0.00]]></additional_shipping_cost>
            <customizable><![CDATA[0]]></customizable>
            <text_fields><![CDATA[0]]></text_fields>
            <uploadable_files><![CDATA[0]]></uploadable_files>
            <active><![CDATA[1]]></active>
            <redirect_type></redirect_type>
            <id_product_redirected><![CDATA[0]]></id_product_redirected>
            <available_for_order><![CDATA[1]]></available_for_order>
            <available_date><![CDATA[0000-00-00]]></available_date>
            <condition><![CDATA[new]]></condition>
            <show_price><![CDATA[1]]></show_price>
            <indexed><![CDATA[1]]></indexed>
            <visibility><![CDATA[both]]></visibility>
            <advanced_stock_management><![CDATA[0]]></advanced_stock_management>
            <date_add><![CDATA[2014-01-22 01:05:20]]></date_add>
            <date_upd><![CDATA[2014-01-22 01:05:20]]></date_upd>
            <meta_description><language id="1" xlink:href="http://localhost.com/api/languages/1"><![CDATA[]]></language><language id="2" xlink:href="http://localhost.com/api/languages/2"><![CDATA[]]></language></meta_description>
            <meta_keywords><language id="1" xlink:href="http://localhost.com/api/languages/1"><![CDATA[]]></language><language id="2" xlink:href="http://localhost.com/api/languages/2"><![CDATA[]]></language></meta_keywords>
            <meta_title><language id="1" xlink:href="http://localhost.com/api/languages/1"><![CDATA[]]></language><language id="2" xlink:href="http://localhost.com/api/languages/2"><![CDATA[]]></language></meta_title>
            <link_rewrite><language id="1" xlink:href="http://localhost.com/api/languages/1"><![CDATA[ipod-nano]]></language><language id="2" xlink:href="http://localhost.com/api/languages/2"><![CDATA[ipod-nano]]></language></link_rewrite>
            <name><language id="1" xlink:href="http://localhost.com/api/languages/1"><![CDATA[iPod Nano]]></language><language id="2" xlink:href="http://localhost.com/api/languages/2"><![CDATA[iPod Nano]]></language></name>
            <description><language id="1" xlink:href="http://localhost.com/api/languages/1"><![CDATA[<p><strong><span style="font-size: small;">Curved ahead of the curve.</span></strong></p>
          <p>For those about to rock, we give you nine amazing colors. But that's only part of the story. Feel the curved, all-aluminum and glass design and you won't want to put iPod nano down.</p>
          <p><strong><span style="font-size: small;">Great looks. And brains, too.</span></strong></p>
          <p>The new Genius feature turns iPod nano into your own highly intelligent, personal DJ. It creates playlists by finding songs in your library that go great together.</p>
          <p><strong><span style="font-size: small;">Made to move with your moves.</span></strong></p>
          <p>The accelerometer comes to iPod nano. Give it a shake to shuffle your music. Turn it sideways to view Cover Flow. And play games designed with your moves in mind.</p>]]></language><language id="2" xlink:href="http://localhost.com/api/languages/2"><![CDATA[]]></language></description>
            <description_short><language id="1" xlink:href="http://localhost.com/api/languages/1"><![CDATA[<p>New design. New features. Now in 8GB and 16GB. iPod nano rocks like never before.</p>]]></language><language id="2" xlink:href="http://localhost.com/api/languages/2"><![CDATA[]]></language></description_short>
            <available_now><language id="1" xlink:href="http://localhost.com/api/languages/1"><![CDATA[In stock]]></language><language id="2" xlink:href="http://localhost.com/api/languages/2"><![CDATA[]]></language></available_now>
            <available_later><language id="1" xlink:href="http://localhost.com/api/languages/1"><![CDATA[]]></language><language id="2" xlink:href="http://localhost.com/api/languages/2"><![CDATA[]]></language></available_later>
          <associations>
            <categories node_type="category">
              <category xlink:href="http://localhost.com/api/categories/2">
              <id><![CDATA[2]]></id>
              </category>
              <category xlink:href="http://localhost.com/api/categories/3">
              <id><![CDATA[3]]></id>
              </category>
            </categories>
            <images node_type="image">
              <image xlink:href="http://localhost.com/api/images/products/1/15">
              <id><![CDATA[15]]></id>
              </image>
            </images>
            <combinations node_type="combinations">
              <combinations xlink:href="http://localhost.com/api/combinations/12">
              <id><![CDATA[12]]></id>
              </combinations>
            </combinations>
            <product_option_values node_type="product_options_values">
              <product_options_values xlink:href="http://localhost.com/api/product_option_values/4">
              <id><![CDATA[4]]></id>
              </product_options_values>
            </product_option_values>
            <product_features node_type="product_feature"/>
            <tags node_type="tag">
              <tag xlink:href="http://localhost.com/api/tags/1">
              <id><![CDATA[1]]></id>
              </tag>
            </tags>
            <stock_availables node_type="stock_available">
              <stock_available xlink:href="http://localhost.com/api/stock_availables/1">
              <id><![CDATA[1]]></id>
              <id_product_attribute><![CDATA[0]]></id_product_attribute>
              </stock_available>
              <stock_available xlink:href="http://localhost.com/api/stock_availables/19">
              <id><![CDATA[19]]></id>
              <id_product_attribute><![CDATA[12]]></id_product_attribute>
              </stock_available>
            </stock_availables>
            <accessories node_type="product"/>
            <product_bundle node_type="products"/>
          </associations>
          </product>
        </prestashop>
        EOF
      end

      it "should find id by reference and id supplier" do
        Product.expects(:find_by).returns(1)
        product.find?
        product.id.must_equal 1
      end

      it "should update model" do 
        Product.expects(:update).with(1, price: 100)
        product.stubs(:id).returns(1)
        product.update(price: 100)
      end

      it "should generate hash of feature" do 
        result = { id: 1, id_feature_value: 2 }
        product.feature_hash(1, 2).must_equal result
      end

      it "should generate hash of id features" do
        id_features = [{id_feature: 1, id_feature_value: 2}]
        product.stubs(:id_features).returns(id_features)
        product.expects(:feature_hash).with(1, 2)
        product.features_hash
      end

      it "should have right reference" do 
        product.reference = ''
        product.name = 'Apple iPhone'
        product.reference.must_equal '000791a4a46769638ea0baae884bb271'
        product.reference = 'apple-iphone'
        product.reference.must_equal 'apple-iphone'
        product.reference = 'apple-iphone-with-reference-longer-then-32-chars-couldnt-be-accepted'
        product.reference.must_equal '45968b3439f3dee47835e975e2cad98c'
      end 
    end 
  end
end