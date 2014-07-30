require_relative 'test_helper'

using Prestashop::Mapper::Refinement
describe 'String' do
  it "should not contains <>;=\#{}" do
    "<>st;r=i#n{g}".plain.must_equal "string"
  end

  it "should remove all html tags" do 
    "I'm <a>Link</a><>".clean.must_equal "I'm Link"
  end

  it "should keep some tags" do 
    "I'm <a>Link</a> and <b>bold</b><>".restricted.must_equal "I'm Link and <b>bold</b>"
  end

  it "should unescape" do
    "<>".restricted.must_equal ""
  end
end