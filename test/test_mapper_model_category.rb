require_relative 'test_helper'

module Prestashop
  module Mapper
    describe Category do
      let(:category) { Category.new(attributes_for(:category)) }
      let(:id_lang) { 2 }
      before do
        xml = <<-EOF
        <?xml version="1.0" encoding="UTF-8"?>
        <prestashop xmlns:xlink="http://www.w3.org/1999/xlink">
          <category>
            <id><![CDATA[1]]></id>
            <id_parent><![CDATA[0]]></id_parent>
            <level_depth><![CDATA[0]]></level_depth>
            <nb_products_recursive not_filterable="true"><![CDATA[7]]></nb_products_recursive>
            <active><![CDATA[1]]></active>
            <id_shop_default><![CDATA[1]]></id_shop_default>
            <is_root_category><![CDATA[0]]></is_root_category>
            <position><![CDATA[1]]></position>
            <date_add><![CDATA[2014-01-22 01:05:06]]></date_add>
            <date_upd><![CDATA[2014-01-22 01:05:06]]></date_upd>
            <name><language id="1" xlink:href="http://localhost.com/api/languages/1"><![CDATA[Root]]></language><language id="2" xlink:href="http://localhost.com/api/languages/2"><![CDATA[Root]]></language></name>
            <link_rewrite><language id="1" xlink:href="http://localhost.com/api/languages/1"><![CDATA[root]]></language><language id="2" xlink:href="http://localhost.com/api/languages/2"><![CDATA[root]]></language></link_rewrite>
            <description><language id="1" xlink:href="http://localhost.com/api/languages/1"><![CDATA[]]></language><language id="2" xlink:href="http://localhost.com/api/languages/2"><![CDATA[]]></language></description>
            <meta_title><language id="1" xlink:href="http://localhost.com/api/languages/1"><![CDATA[]]></language><language id="2" xlink:href="http://localhost.com/api/languages/2"><![CDATA[]]></language></meta_title>
            <meta_description><language id="1" xlink:href="http://localhost.com/api/languages/1"><![CDATA[]]></language><language id="2" xlink:href="http://localhost.com/api/languages/2"><![CDATA[]]></language></meta_description>
            <meta_keywords><language id="1" xlink:href="http://localhost.com/api/languages/1"><![CDATA[]]></language><language id="2" xlink:href="http://localhost.com/api/languages/2"><![CDATA[]]></language></meta_keywords>
          <associations>
            <categories node_type="category">
              <category xlink:href="http://localhost.com/api/categories/2">
              <id><![CDATA[2]]></id>
              </category>
            </categories>
            <products node_type="product"/>
            </associations>
          </category>
        </prestashop>
        EOF
      end

      it "should have valid name" do 
        category.name = ';#Apple<>'
        category.name.must_equal 'Apple'
        category.name = LONG_STRING
        category.name.length.must_equal 61
      end

      it "should have valid description" do 
        category.description = ';#<a>Apple</a>'
        category.description.must_equal ';#Apple'
        category.description = LONG_STRING
        category.description.length.must_equal 252
      end

      it "should have valid link rewrite" do 
        category.link_rewrite.must_equal 'apple'
        category.link_rewrite = 'Apple iPhone'
        category.link_rewrite.must_equal 'apple-iphone'
      end

      it "should look for category in cache" do 
        Category.expects(:find_in_cache).returns({id: 1})
        category.find_or_create.must_equal 1
      end

      it "should create new one, when is not find in cache" do 
        Category.expects(:find_in_cache).returns(false)
        Category.any_instance.expects(:create).returns({id: 1})
        Client.expects(:clear_categories_cache)
        category.find_or_create.must_equal 1
      end

      it "should look for category in cache" do
        cache = [{ id_parent: 1, name: { language: { val: 'Apple',  attr: { id: 2 }}}} ]
        Client.stubs(:categories_cache).returns(cache)
        Category.find_in_cache(1, 'Apple', 2).must_equal cache.first
        Category.find_in_cache(2, 'Apple', 2).must_equal nil
      end

      it "should cache by calling all" do 
        Category.expects(:all)
        Category.cache
      end

      it "should create from name" do
        cat = mock('category')
        Category.expects(:new).returns(cat)
        cat.expects(:find_or_create).once
        Category.create_from_name 'Apple', id_lang
      end

      it "should create from name" do
        cat = mock('category')
        cat.stubs(:find_or_create).returns(3)
        Category.expects(:new).with({name: 'Apple', id_parent: 2, id_lang: id_lang}).returns(cat)
        Category.expects(:new).with({name: 'iPhone', id_parent: 3, id_lang: id_lang}).returns(cat)
        Category.create_from_name 'Apple||iPhone', id_lang
      end

      it "should generate correct hash from array" do 
        cat_name = 'Apple||iPhone||Accessories'
        cat_name2 = 'Apple||Accessories'
        Category.stubs(:create_from_name).with(cat_name, id_lang).returns([1,2,3])
        Category.stubs(:create_from_name).with(cat_name2, id_lang).returns([1,4])
        Category.create_from_names([cat_name, cat_name2], id_lang).must_equal([1,2,3,4])
      end
    end 
  end
end