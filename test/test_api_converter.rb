require_relative 'test_helper'

module Prestashop
  module Api
    describe Converter do
      let(:hash) { { name: 'Steve', company: 'Apple' } }
      let(:xml) { '<prestashop xmlns:xlink="http://www.w3.org/1999/xlink"><user><name><![CDATA[Steve]]></name><company><![CDATA[Apple]]></company></user></prestashop>' }

      it "should generate xml" do 
        Converter.to_xml(:users, :user, hash).must_equal xml
      end

      it "should generate xml with array" do 
        Converter.from_xml(xml).must_equal({ user: hash })
      end
    end
  end
end