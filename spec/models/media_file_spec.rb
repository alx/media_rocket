require "ftools"
require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe MediaRocket::MediaFile do
  
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
  
  it "should not create a new Media out of nothing" do
    MediaRocket::MediaFile.new.should nil
  end
  
  it "should create a new Media with image" do
    @media = MediaRocket::MediaFile.new :file => test_file
    @media.should_not be(nil)
    @media.is_image?.should == true
    @media.path.should_not be(nil)
  end
  
  it "should save a new Media with image" do
    @media = MediaRocket::MediaFile.new :file => test_file
    @media.save.should == true
  end
  
  it "should create a unique Media if conflict on name" do
    @media = MediaRocket::MediaFile.new :file => test_file
    
    # File has been moved, recreate it
    File.copy(origin_file, test_file[:tempfile].path)
    sleep 2
    @media2 = MediaRocket::MediaFile.new :file => test_file
    
    @media.path.should_not == @media2.path
  end
  
  it "should create a new Media with image and tags" do
    @media = MediaRocket::MediaFile.new :file => test_file, :tags => "image+tested"
    @media.tag_list.size.should == 2
    @media.tag_list.first.should == "image"
  end
  
  it "should create a new Media with image and tags with delimiter" do
    @media = MediaRocket::MediaFile.new :file => test_file, :tags => "image, tested", :delimiter => ","
    @media.tag_list.size.should == 2
    @media.tag_list.first.should == "image"
  end
  
  it "should create a new Media belonging to a site" do
    site_name = "domain.com"
    
    @media = MediaRocket::MediaFile.new :file => test_file, :site_name => site_name
    @media.site.should_not be(nil)
    @media.site.name.should == site_name
  end
  
  it "should create a new Media belonging to a site with a category" do
    site_name = "domain.com"
    category_name = "vacances"
    
    @media = MediaRocket::MediaFile.new :file => test_file, :site_name => site_name, :category_name => category_name
    @media.save
    @site = @media.site
    @category = @media.category
    
    @site.should_not be(nil)
    @site.name.should == site_name
    @category.should_not be(nil)
    @category.name.should == category_name
    
    @first_site = MediaRocket::Site.first :name => site_name
    @first_category = MediaRocket::Gallery.first :name => category_name
    
    @site.id.should == @first_site.id
    @first_site.categories.size.should == 1
    @first_site.categories.first.id.should == @first_category.id
    @first_site.medias.size.should == 3
    @first_site.medias.first.path.should == @media.path
    
    @first_category.medias.size.should == 3
    @first_category.medias.first.path.should == @media.path
  end
  
  it "should create a new Media within a special-character category" do
    site_name = "domain.com"
    category_name = "vaca nces"
    
    @media = MediaRocket::MediaFile.new :file => test_file, :site_name => site_name, :category_name => category_name
    @media.save
    @site = @media.site
    @category = @media.category
    
    @site.medias.size.should == 3
    @site.medias.first.path.should == @media.path
    @media.files.each do |media|
      Merb.logger.info media.path
      File.exists?(media.path).should be(true)
    end
    
    @category.medias.size.should == 3
    @category.medias.first.path.should == @media.path
  end
  
  it "should not create a new category if site is not specified" do
    category_name = "vacances"
    @media = MediaRocket::MediaFile.new :file => test_file, :category_name => category_name
    @media.site.should be(nil)
    @media.category.should be(nil)
  end
  
  it "should not create a new category if site is not specified" do
    site_name = "domain.com"
    category_name = "vacances"
    
    @media = MediaRocket::MediaFile.new :file => test_file, :site_name => "site_name", :new_category => "", :category_name => category_name
    
    @media.category.should_not be(nil)
    @media.category.name.should == category_name
  end
  
  it "should cleanly destroy a media" do
    site_name = "domain.com"
    category_name = "vacances"
    
    @media = MediaRocket::MediaFile.new :file => test_file, :site_name => site_name, :category_name => category_name
    @media.save
    
    medias_size = MediaRocket::MediaFile.all.size
    
    @site = @media.site
    site_size = @site.medias.size
    
    @category = @media.category
    category_size = @category.medias.size
    
    file_path = @media.path
    @children = @media.files
    @children_path = []
    @children.each{ |child| @children_path << child.path}
    
    @media.destroy
    
    File.exists?(file_path).should be(false)
    @children_path.each{ |path| File.exists?(path).should be(false)}
    
    MediaRocket::MediaFile.all.size == (medias_size - 3)
    @site.medias.size.should == (site_size - 3)
    @category.medias.size.should == (category_size - 3)
  end
  
  it "should save modified description" do
    description = " description image bout vin et blabla et bloblo "
    
    @media = MediaRocket::MediaFile.new :file => test_file, :description => description
    @media.save
    
    @media.description.should == description
    
    new_description = " description image bout pot et blabla et bloblo "
    @media.update_attributes :title => "title",
                             :description => new_description
    
    @media.description.should == new_description
  end
  
  it "should inform about image size" do
    @media = MediaRocket::MediaFile.new :file => test_file
    @media.save
    
    @media.should_not be(nil)
    @media.is_image?.should == true
    
    @media.dimension_max.should be(nil)
    @media.dimension_x.should == 170
    @media.dimension_y.should == 170
    
    @media.thumbnail.dimension_max.should == "130x130"
    @media.thumbnail.dimension_x.should == 130
    @media.thumbnail.dimension_y.should == 130
  end
end