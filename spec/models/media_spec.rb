require "ftools"
require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe MediaRocket::Media do
  
  origin_file = File.join( MediaRocket.root, 'public', 'images', 'rocket.png' )
  test_file = {:filename => 'image.png', :tempfile => Tempfile.new('image.png')}
  
  before(:each) do
    FileUtils.rm_r Dir.glob("#{MediaRocket.root}/public/uploads/image*")
    FileUtils.rm_rf Dir.glob("#{MediaRocket.root}/public/uploads/domain.com/")
    FileUtils.rm_rf Dir.glob("#{MediaRocket.root}/public/uploads/vacances/")
    File.copy(origin_file, test_file[:tempfile].path)
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
  
  it "should save a new Media with image" do
    @media = MediaRocket::Media.new :file => test_file
    @media.save.should == true
  end
  
  it "should create a unique Media if conflict on name" do
    @media = MediaRocket::Media.new :file => test_file
    
    # File has been moved, recreate it
    File.copy(origin_file, test_file[:tempfile].path)
    @media2 = MediaRocket::Media.new :file => test_file
    
    @media.url.should == @media2.path
    @media.url.should == "/file/image.png"
    @media2.url.should == "/file/image0.png"
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
    site_name = "domain.com"
    if site = MediaRocket::Site.first(:name => site_name)
      site.destroy
    end
    @media = MediaRocket::Media.new :file => test_file, :site => site_name
    @media.site.should_not be(nil)
    @media.site.name.should == site_name
    # Clean site
    MediaRocket::Site.first(:name => site_name).destroy
  end
  
  it "should create a new Media belonging to a category" do
    category_name = "vacances"
    if category = MediaRocket::Category.first(:name => category_name)
      category.destroy
    end
    @media = MediaRocket::Media.new :file => test_file, :category => category_name
    @media.category.should_not be(nil)
    @media.category.name.should == category_name
    # Clean site
    MediaRocket::Category.first(:name => category_name).destroy
  end
end