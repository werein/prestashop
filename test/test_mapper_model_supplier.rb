require_relative 'test_helper'

module Prestashop
  module Mapper
    describe Supplier do
      let(:supplier) { Supplier.new(attributes_for(:supplier)) }

      it "must have valid hash" do 
        supplier.hash.must_equal({ active: 1, name: 'Apple' })
      end

      it "must find from API" do 
        Supplier.expects(:find_by).returns(1)
        supplier.find_or_create.must_equal 1
      end

      it "must create new one, when doesnt exist" do 
        Supplier.expects(:find_by).returns(false)
        supplier.stubs(:create).returns({id: 1})
        supplier.find_or_create.must_equal 1
      end

      it "should raise error" do 
        -> {  supplier.active = true
              supplier.validate! }.must_raise ArgumentError        
        -> {  supplier.name = :apple
              supplier.validate! }.must_raise ArgumentError
      end
    end 
  end
end
