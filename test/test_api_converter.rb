require_relative 'test_helper'

module Prestashop
  module Api
    describe Converter do
      let(:user) { { name: 'Steve', company: 'Apple' } }
      let(:xml) { '<prestashop xmlns:xlink="http://www.w3.org/1999/xlink"><user><name><![CDATA[Steve]]></name><company><![CDATA[Apple]]></company></user></prestashop>' }

      it "should generate xml" do 
        Converter.build(:users, :user, user).must_equal xml
      end

      it "should generate xml with array" do 
        Converter.parse(xml).must_equal({ user: user })
      end
    end
  end
end