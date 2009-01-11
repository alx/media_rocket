require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe MediaRocket::Main do

  before(:each) do
    @controller = do_request(MyController, :index) do |controller|
      controller.should_receive(:render).with(:new)
    end
  end

  it "should render successfully" do
    @controller.should render_successfully
  end
end