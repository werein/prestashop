require_relative 'test_helper'

module Prestashop
  module Mapper
    describe ProductFeature do
      let(:feature) { ProductFeature.new(attributes_for(:product_feature_basic)) }
      before do 
        xml = <<-EOT
        <?xml version="1.0" encoding="UTF-8"?>
        <prestashop xmlns:xlink="http://www.w3.org/1999/xlink">
          <product_features>
            <product_feature>
              <id><![CDATA[1]]></id>
              <position><![CDATA[0]]></position>
              <name><language id="2" xlink:href="http://dev.demo.storio.cz/api/languages/2"><![CDATA[CPU]]></language></name>
            </product_feature>
          </product_features>
        </prestashop>
        EOT
      end

      it "must have valid hash" do
        result = { name: { language: { val: 'CPU',  attr: { id: 2 }}}}
        feature.hash.must_equal result
      end

      it "must find from API" do 
        ProductFeature.expects(:find_in_cache).returns({id: 1})
        feature.find_or_create.must_equal 1
      end

      it "must create new one, when doesnt exist" do
        Client.stubs(:clear_features_cache).returns(true)
        ProductFeature.expects(:find_in_cache).returns(false)
        feature.stubs(:create).returns({id: 1})
        feature.find_or_create.must_equal 1
      end

      it "should raise error" do 
        -> {  feature.id_lang = '1'
              feature.validate! }.must_raise ArgumentError        
        -> {  feature.name = :apple
              feature.validate! }.must_raise ArgumentError
      end

      it "should find in cache" do 
        cache = [ { name: { language: { val: 'Capacity',  attr: { id: 2 }}}, id: 1},
                  { name: { language: { val: 'Color',  attr: { id: 2 }}}, id: 2} ]
        Client.stubs(:features_cache).returns(cache)
        ProductFeature.find_in_cache('Capacity', 2).must_equal(cache[0])
      end

      it "should generate cache" do
        ProductFeature.expects(:all).with(display: '[id,name]')
        ProductFeature.cache
      end

      it "should generate correct hash from string" do
        feature = { feature: 'CPU', value: 'Intel' }
        ProductFeature.any_instance.stubs(:find_or_create).returns(1)
        ProductFeatureValue.any_instance.stubs(:find_or_create).returns(2)
        ProductFeature.create_from_hash(feature, 2).must_equal([{ id_feature: 1, id_feature_value: 2 }])
      end

      it "should generate correct hash from string" do
        feature = [{ feature: 'CPU', value: 'Intel' }]
        ProductFeature.any_instance.stubs(:find_or_create).returns(1)
        ProductFeatureValue.any_instance.stubs(:find_or_create).returns(2)
        ProductFeature.create_from_hash(feature, 2).must_equal([{ id_feature: 1, id_feature_value: 2 }])
      end
    end 
  end
end
