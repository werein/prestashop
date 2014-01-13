require_relative 'test_helper'

module Prestashop
  module Mapper
    describe Product do
      let(:product) { Product.new(attributes_for(:product)) }
      before do
        @settings =  mock 'settings'
        @settings.stubs(:id_supplier).returns(1)
        @settings.stubs(:available_now).returns('Available now')
        @settings.stubs(:available_later).returns('Available later')
        Product.stubs(:settings).returns(@settings)
        Product.any_instance.stubs(:settings).returns(@settings)
      end
  
      it "should make hash of id" do
        product.hash_id(1).must_equal({id: 1})
      end      

      it "should generate hash of category ids" do 
        product.hash_ids([1,2,3]).must_equal [{id: 1}, {id: 2}, {id: 3}]
      end

      it "should generate hash of feature" do 
        result = { id: 1, id_feature_value: 'Apple' }
        product.feature_hash(id_feature: 1, id_feature_value: 'Apple').must_equal result
      end
    end 
  end
end
