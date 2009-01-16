require "ftools"
require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe MediaRocket::Gallery do
  
  origin_file = File.join( MediaRocket.root, 'public', 'images', 'rocket.png' )
  test_file = {:filename => 'image.png', :tempfile => Tempfile.new('image.png')}
  
  before(:each) do
    FileUtils.rm_r Dir.glob("#{MediaRocket.root}/public/uploads/image*")
    FileUtils.rm_rf Dir.glob("#{MediaRocket.root}/public/uploads/domain.com/")
    FileUtils.rm_rf Dir.glob("#{MediaRocket.root}/public/uploads/vacances/")
    File.copy(origin_file, test_file[:tempfile].path)
    
    MediaRocket::Gallery.all.destroy!
    MediaRocket::Site.all.destroy!
  end
  
  it "should contains media" do
    @media = MediaRocket::MediaFile.new :file => test_file
    @category = MediaRocket::Gallery.new :name => "Vacances"
    @category.medias << @media
    
    @category.medias.should_not be(nil)
    @category.medias.size.should == 1
  end
  
  it "should belongs to a site" do
    @category = MediaRocket::Gallery.new :name => "Vacances"
    @site = MediaRocket::Site.new :name => "domain.com"
    
    @site.categories << @category
    @site.categories.size.should == 1
  end
  
  it "should accept sub-categories" do
    @site = MediaRocket::Site.create :name => "domain.com"
    @category = @site.categories.create :name => "Vacances"
    @child = @category.add_child("hiver")
    
    @child.ancestors.first.name.should == @category.name
    @child.site.name.should == @site.name
  end
  
  it "should compose url with sub-categories" do
    @site = MediaRocket::Site.create :name => "domain.com"
    @category = @site.categories.create :name => "Vacances"
    @child = @category.add_child("hiver")
    
    @media = MediaRocket::MediaFile.new :file => test_file,
                                        :site => @site.name,
                                        :category => @child.name
    
    @media.path.to_s.should == File.join(Merb.root, 'public', 'uploads', @site.name, @category.name, @child.name, test_file[:filename])
  end
end