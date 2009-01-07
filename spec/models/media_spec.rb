require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe MediaRocket::Media do
  
  image_file = File.join( File.dirname(__FILE__), '..', 'resources', "image.png" )
  
  it "should not create a new Media with nothing" do
    MediaRocket::Media.new.should nil
  end
  
  it "should create a new Media with image" do
    @media = MediaRocket::Media.new :file => image_file
    @media.should_not nil
  end
  
  it "should create a new Media with image and tags" do
    @media = MediaRocket::Media.new :file => image_file, :tags => "image+tested"
    
    tag_list = @media.tag_list
    tag_list.size.should == 2
    tag_list.first.should == "image"
  end
  
  # it "should create a new Media with image and tags with delimiter" do
  #   @media = MediaRocket::Media.new :file => image_file, :tags => "image, tested", :delimiter => ", "
  #   @media.tag_list.size.should == 2
  #   @media.tag_list.first.should == "image"
  # end
end