require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/category" do
  before(:each) do
    @response = request("/category")
  end
end