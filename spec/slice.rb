require File.dirname(__FILE__) + '/spec_helper'

describe "Slice (module)" do
  
  # Implement your Slice specs here
  
  # To spec Slice you need to hook it up to the router like this:
  
  before :all do
    Merb::Router.prepare { add_slice(:Slice) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
    
  it "should have proper specs"
  
end