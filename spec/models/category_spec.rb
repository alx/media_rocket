require "ftools"
require 'cgi'
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
    @gallery = MediaRocket::Gallery.new :name => "Vacances"
    @gallery.medias << @media
    
    @gallery.medias.should_not be(nil)
    @gallery.medias.size.should == 1
  end
  
  it "should belongs to a site" do
    @gallery = MediaRocket::Gallery.new :name => "Vacances"
    @site = MediaRocket::Site.new :name => "domain.com"
    
    @site.galleries << @gallery
    @site.galleries.size.should == 1
  end
  
  it "should accept sub-galleries" do
    @site = MediaRocket::Site.create :name => "domain.com"
    @gallery = @site.galleries.create :name => "Vacances"
    @child = @gallery.add_child("hiver")
    
    @child.ancestors.first.name.should == @gallery.name
    @child.site.name.should == @site.name
  end
end