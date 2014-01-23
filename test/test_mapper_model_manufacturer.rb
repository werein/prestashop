require_relative 'test_helper'

module Prestashop
  module Mapper
    describe Manufacturer do
      let(:manufacturer) { Manufacturer.new(attributes_for(:manufacturer_basic)) }

      before do 
        xml = <<-EOT
        <?xml version="1.0" encoding="UTF-8"?>
        <prestashop xmlns:xlink="http://www.w3.org/1999/xlink">
          <manufacturer>
            <id><![CDATA[1]]></id>
            <active><![CDATA[1]]></active>
            <link_rewrite not_filterable="true"><![CDATA[apple]]></link_rewrite>
            <name><![CDATA[Apple]]></name>
            <date_add><![CDATA[2014-01-21 21:41:28]]></date_add>
            <date_upd><![CDATA[2014-01-21 21:41:28]]></date_upd>
            <description><language id="2" xlink:href="http://dev.demo.storio.cz/api/languages/2"><![CDATA[]]></language></description>
            <short_description><language id="2" xlink:href="http://dev.demo.storio.cz/api/languages/2"><![CDATA[]]></language></short_description>
            <meta_title><language id="2" xlink:href="http://dev.demo.storio.cz/api/languages/2"><![CDATA[Apple]]></language></meta_title>
            <meta_description><language id="2" xlink:href="http://dev.demo.storio.cz/api/languages/2"><![CDATA[]]></language></meta_description>
            <meta_keywords><language id="2" xlink:href="http://dev.demo.storio.cz/api/languages/2"><![CDATA[Apple]]></language></meta_keywords>
            <associations>
              <addresses node_type="address"/>
            </associations>
          </manufacturer>
        </prestashop>
        EOT
      end

      it "must have valid hash" do
        result = { active: 1,  name: "Apple",  description: nil,  short_description: nil,  meta_title: { language: { val: "Apple",  attr: { id: 2}}},  meta_description: nil,  meta_keywords: { language: { val: "Apple",  attr: { id: 2}}}}
        manufacturer.hash.must_equal result
      end

      it "must have shorter name" do 
        manufacturer.name = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
        manufacturer.name.length.must_equal 125
      end

      it "must have description" do 
        manufacturer.description = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
        manufacturer.description.length.must_equal 252
      end

      it "must have shor description" do 
        manufacturer.short_description = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
        manufacturer.short_description.length.must_equal 252
      end

      it "must find from cache" do 
        Manufacturer.expects(:find_in_cache).returns({id: 1})
        manufacturer.find_or_create.must_equal 1
      end

      it "must create new one, when doesnt exist" do
        Client.stubs(:clear_manufacturers_cache).returns(true)
        Manufacturer.expects(:find_in_cache).returns(false)
        manufacturer.stubs(:create).returns({id: 1})
        manufacturer.find_or_create.must_equal 1
      end

      it "should raise error" do 
        -> {  manufacturer.id_lang = '1'
              manufacturer.validate! }.must_raise ArgumentError      
        -> {  manufacturer.active = '1'
              manufacturer.validate! }.must_raise ArgumentError        
        -> {  manufacturer.name = :apple
              manufacturer.validate! }.must_raise ArgumentError
      end

      it "should find in cache" do 
        cache = [ { name: 'Apple', id: 1},
                  { name: 'IBM', id: 2} ]
        Client.stubs(:manufacturers_cache).returns(cache)
        Manufacturer.find_in_cache('Apple').must_equal(cache[0])
      end

      it "should generate cache" do
        Manufacturer.expects(:all).with(display: '[id,name]')
        Manufacturer.cache
      end
    end 
  end
end
