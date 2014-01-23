require_relative 'test_helper'

module Prestashop
  module Mapper
    describe StockAvailable do
      let(:stock_available) { StockAvailable.new(attributes_for(:stock_available_basic)) }
      before do 
        xml = <<-EOT
          <?xml version="1.0" encoding="UTF-8"?>
          <prestashop xmlns:xlink="http://www.w3.org/1999/xlink">
          <stock_available>
            <id><![CDATA[1]]></id>
            <id_product xlink:href="http://dev.demo.storio.cz/api/products/1"><![CDATA[1]]></id_product>
            <id_product_attribute><![CDATA[0]]></id_product_attribute>
            <id_shop xlink:href="http://dev.demo.storio.cz/api/shops/1"><![CDATA[1]]></id_shop>
            <id_shop_group><![CDATA[0]]></id_shop_group>
            <quantity><![CDATA[10]]></quantity>
            <depends_on_stock><![CDATA[0]]></depends_on_stock>
            <out_of_stock><![CDATA[2]]></out_of_stock>
          </stock_available>
          </prestashop>
        EOT
      end

      it "should find id by id product, when is not specified" do
        StockAvailable.expects(:find_by).with('filter[id_product]' => 1).returns(1)
        stock_available.id.must_equal 1
      end

      it "should find id by id product, when is not specified" do
        StockAvailable.expects(:find_by).with('filter[id_product]' => 1, 'filter[id_product_attribute]' => 10).returns(1)
        stock_available.id_product_attribute = 10
        stock_available.id.must_equal 1
      end

      it "should have id defined" do 
        StockAvailable.new(attributes_for(:stock_available)).id.must_equal 1
      end

      it "should update stock" do 
        stock_available = StockAvailable.new(attributes_for(:stock_available))
        StockAvailable.expects(:update).with(1, quantity: 10)
        stock_available.update(quantity: 10)
      end
    end 
  end
end
