require "ftools"
require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe MediaRocket::Media do
  
  origin_file = File.join( MediaRocket.root, 'public', 'images', 'rocket.png' )
  test_file = File.join( MediaRocket.root, 'spec', 'resources', 'image.png' )
  public_file = File.join( MediaRocket.root, 'public', 'uploads', 'image.png' )
  
  before(:each) do
    FileUtils.rm_r Dir.glob("#{MediaRocket.root}/public/uploads/image.png*")
    File.copy(origin_file, test_file)
  end
  
  it "should not create a new Media out of nothing" do
    MediaRocket::Media.new.should nil
  end
  
  it "should create a new Media with image" do
    @media = MediaRocket::Media.new :file => test_file
    @media.should_not be(nil)
    @media.path.should_not be(nil)
    @media.url.should == "/uploads/image.png"
  end
  
  it "should create a unique Media if conflict on name" do
    @media = MediaRocket::Media.new :file => test_file
    
    # File has been moved, recreate it
    File.copy(origin_file, test_file)
    @media2 = MediaRocket::Media.new :file => test_file
    
    @media.path.should_not == @media2.path
    @media.url.should == "/uploads/image.png"
    @media2.url.should == "/uploads/image.png0"
  end
  
  it "should create a new Media with image and tags" do
    @media = MediaRocket::Media.new :file => test_file, :tags => "image+tested"
    tag_list = @media.tag_list
    tag_list.size.should == 2
    tag_list.first.should == "image"
  end
  
  it "should create a new Media with image and tags with delimiter" do
    @media = MediaRocket::Media.new :file => test_file, :tags => "image, tested", :delimiter => ", "
    @media.tag_list.size.should == 2
    @media.tag_list.first.should == "image"
  end
  
  it "should create a new Media belonging to a site" do
    @media = MediaRocket::Media.new :file => test_file, :site => "domain.com"
    @media.site.should_not be(nil)
    @media.site.name.should == "domain.com"
    # Clean site
    MediaRocket::Site.first(:name => "domain.com").destroy
  end
end