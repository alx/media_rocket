require "ftools"
require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe MediaRocket::Category do
  
  origin_file = File.join( MediaRocket.root, 'public', 'images', 'rocket.png' )
  test_file = {:filename => 'image.png', :tempfile => Tempfile.new('image.png')}
  
  before(:each) do
    FileUtils.rm_r Dir.glob("#{MediaRocket.root}/public/uploads/image*")
    FileUtils.rm_rf Dir.glob("#{MediaRocket.root}/public/uploads/domain.com/")
    FileUtils.rm_rf Dir.glob("#{MediaRocket.root}/public/uploads/vacances/")
    File.copy(origin_file, test_file[:tempfile].path)
  end
  
  it "should contains media" do
    @media = MediaRocket::Media.new :file => test_file
    @category = MediaRocket::Category.new :name => "Vacances"
    @category.medias << @media
    
    @category.medias.should_not be(nil)
    @category.medias.size.should == 1
  end
  
  it "should belongs to a site" do
    @category = MediaRocket::Category.new :name => "Vacances"
    @site = MediaRocket::Site.new :name => "domain.com"
    
    @site.categories << @category
    @site.categories.size.should == 1
  end
end