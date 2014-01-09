require_relative 'test_helper'

module Prestashop
  module Mapper
    describe Category do
      let(:category) { Category.new(attributes_for(:category)) }
      before do
        @settings =  mock 'settings'
        Category.stubs(:settings).returns(@settings)
        Category.any_instance.stubs(:settings).returns(@settings)
      end

      it "should have valid name" do 
        cat = Category.new(attributes_for(:category, name: ';#Apple<>' + LONG_STRING))
        cat.name.length.must_equal 61
      end

      it "should have valid description" do 
        cat = Category.new(attributes_for(:category, description: ';#<a>Apple</a>' + LONG_STRING))
        cat.description.length.must_equal 252
      end

      it "should have valid link rewrite" do 
        category.link_rewrite.must_equal 'apple'
        cat = Category.new(attributes_for(:category, link_rewrite: 'Apple iPhone'))
        cat.link_rewrite.must_equal 'apple-iphone'
      end

      it "should look for category in cache" do 
        Category.expects(:find_in_cache).returns({id: 1})
        category.find_or_create.must_equal 1
      end

      it "should create new one, when is not find in cache" do 
        Category.expects(:find_in_cache).returns(false)
        Category.any_instance.expects(:create).returns({id: 1})
        @settings.expects(:clear_categories_cache)
        category.find_or_create.must_equal 1
      end

      it "should look for category in cache" do
        name = mock 'name'
        name.expects(:lang_search).returns(true)
        cache = [{id_parent: {val: 1}, name: name }]
        @settings.stubs(:categories_cache).returns(cache)
        Category.find_in_cache(id_parent: 1, name: 'Apple').must_equal cache.first
        Category.find_in_cache(id_parent: 2, name: 'Apple').must_equal nil
      end

      it "should cache by calling all" do 
        Category.expects(:all)
        Category.cache
      end

      it "should create from name" do
        cat = mock('category')
        @settings.stubs(:delimiter).returns('|')
        Category.expects(:new).returns(cat)
        cat.expects(:find_or_create).once
        Category.create_from_name 'Apple'
      end
    end 
  end
end
