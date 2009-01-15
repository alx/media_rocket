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
    
    MediaRocket::Category.all.destroy!
    MediaRocket::Site.all.destroy!
  end
  
  it "should not create a new Media out of nothing" do
    MediaRocket::Media.new.should nil
  end
  
  it "should create a new Media with image" do
    @media = MediaRocket::Media.new :file => test_file
    @media.should_not be(nil)
    @media.is_image?.should == true
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
    
    @media.path.should_not == @media2.path
    @media.url.should == "/uploads/image.png"
    @media2.url.should == "/uploads/image0.png"
  end
  
  it "should create a new Media with image and tags" do
    @media = MediaRocket::Media.new :file => test_file, :tags => "image+tested"
    @media.tag_list.size.should == 2
    @media.tag_list.first.should == "image"
  end
  
  it "should create a new Media with image and tags with delimiter" do
    @media = MediaRocket::Media.new :file => test_file, :tags => "image, tested", :delimiter => ","
    @media.tag_list.size.should == 2
    @media.tag_list.first.should == "image"
  end
  
  it "should create a new Media belonging to a site" do
    site_name = "domain.com"
    
    @media = MediaRocket::Media.new :file => test_file, :site => site_name
    @media.site.should_not be(nil)
    @media.site.name.should == site_name
  end
  
  it "should create a new Media belonging to a site with a category" do
    site_name = "domain.com"
    category_name = "vacances"
    
    @media = MediaRocket::Media.new :file => test_file, :site => site_name, :category => category_name
    @media.save
    @site = @media.site
    @category = @media.category
    
    @site.should_not be(nil)
    @site.name.should == site_name
    @category.should_not be(nil)
    @category.name.should == category_name
    
    @first_site = MediaRocket::Site.first :name => site_name
    @first_category = MediaRocket::Category.first :name => category_name
    
    @site.id.should == @first_site.id
    @first_site.categories.size.should == 1
    @first_site.categories.first.id.should == @first_category.id
    @first_site.medias.size.should == 1
    @first_site.medias.first.path.should == @media.path
    
    @first_category.medias.size.should == 1
    @first_category.medias.first.path.should == @media.path
  end
  
  it "should not create a new category if site is not specified" do
    category_name = "vacances"
    @media = MediaRocket::Media.new :file => test_file, :category => category_name
    @media.site.should be(nil)
    @media.category.should be(nil)
  end
end