require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/queue" do
  before(:each) do
    @response = request("/queue")
  end
end