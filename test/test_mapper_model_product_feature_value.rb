require_relative 'test_helper'

module Prestashop
  module Mapper
    describe ProductFeatureValue do
      let(:feature_value) { ProductFeatureValue.new(attributes_for(:product_feature_value_basic)) }
      before do 
        xml = <<-EOT
        <?xml version="1.0" encoding="UTF-8"?>
        <prestashop xmlns:xlink="http://www.w3.org/1999/xlink">
          <product_feature_values>
            <product_feature_value>
              <id><![CDATA[1]]></id>
              <id_feature xlink:href="http://dev.demo.storio.cz/api/product_features/1"><![CDATA[1]]></id_feature>
              <custom><![CDATA[0]]></custom>
              <value><language id="2" xlink:href="http://dev.demo.storio.cz/api/languages/2"><![CDATA[Intel]]></language></value>
            </product_feature_value>
          </product_feature_values>
        </prestashop>
        EOT
      end

      it "must have valid hash" do
        result = { id_feature: 1,  custom: 0,  value: { language: { val: "Intel",  attr: { id: 2}}}}
        feature_value.hash.must_equal result
      end

      it "must find from API" do 
        ProductFeatureValue.expects(:find_in_cache).returns({id: 1})
        feature_value.find_or_create.must_equal 1
      end

      it "must create new one, when doesnt exist" do
        Client.stubs(:clear_feature_values_cache).returns(true)
        ProductFeatureValue.expects(:find_in_cache).returns(false)
        feature_value.stubs(:create).returns({id: 1})
        feature_value.find_or_create.must_equal 1
      end

      it "should raise error" do 
        -> {  feature_value.id_lang = '1'
              feature_value.validate! }.must_raise ArgumentError        
        -> {  feature_value.id_feature = 'a'
              feature_value.validate! }.must_raise ArgumentError
        -> {  feature_value.custom = 3
              feature_value.validate! }.must_raise ArgumentError
        -> {  feature_value.value = :apple
              feature_value.validate! }.must_raise ArgumentError
      end

      it "should find in cache" do 
        cache = [ { id_feature: 1,  custom: 0,  value: { language: { val: "Intel",  attr: { id: 2 }}}},
                  { id_feature: 1,  custom: 0,  value: { language: { val: "AMD",  attr: { id: 2 }}}} ]
        Client.stubs(:feature_values_cache).returns(cache)
        ProductFeatureValue.find_in_cache(1, 'Intel', 2).must_equal(cache[0])
      end

      it "should generate cache" do
        ProductFeatureValue.expects(:all).with(display: '[id,id_feature,value]')
        ProductFeatureValue.cache
      end
    end 
  end
end
