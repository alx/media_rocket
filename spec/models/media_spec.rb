require "ftools"
require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe MediaRocket::Media do
  
  image_file = File.join( File.dirname(File.expand_path(__FILE__)), '..', 'resources', "image.png" )
  
  before(:each) do
    public_file = File.join( MediaRocket.root, 'public', 'uploads', 'image.png' )
    test_file = File.join( MediaRocket.root, 'spec', 'resources', 'image.png' )
    origin_file = File.join( MediaRocket.root, 'public', 'images', 'rocket.png' )
    
    File.unlink(public_file) if File.exists?(public_file)
    File.copy(origin_file, test_file) unless File.exists?(test_file)
  end
  
  it "should not create a new Media out of nothing" do
    MediaRocket::Media.new.should nil
  end
  
  it "should create a new Media with image" do
    @media = MediaRocket::Media.new :file => image_file
    @media.should_not nil
    @media.path.should_not nil
    @media.url.should "/file/image.png"
  end
  
  it "should create a new Media with image and tags" do
    @media = MediaRocket::Media.new :file => image_file, :tags => "image+tested"
    tag_list = @media.tag_list
    tag_list.size.should == 2
    tag_list.first.should == "image"
  end
  
  it "should create a new Media with image and tags with delimiter" do
    @media = MediaRocket::Media.new :file => image_file, :tags => "image, tested", :delimiter => ", "
    @media.tag_list.size.should == 2
    @media.tag_list.first.should == "image"
  end
end