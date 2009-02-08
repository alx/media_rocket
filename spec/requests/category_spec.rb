require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/gallery" do
  before(:each) do
    @response = request("/gallery")
  end
end