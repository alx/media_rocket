require "ftools"
require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe MediaRocket::AssociatedFile do

  origin_file = File.join( MediaRocket.root, 'public', 'images', 'rocket.png' )
  test_file = {:filename => 'image.png', :tempfile => Tempfile.new('image.png')}
  
  before(:each) do
    FileUtils.rm_r Dir.glob("#{MediaRocket.root}/public/uploads/image*")
    FileUtils.rm_rf Dir.glob("#{MediaRocket.root}/public/uploads/domain.com/")
    FileUtils.rm_rf Dir.glob("#{MediaRocket.root}/public/uploads/vacances/")
    File.copy(origin_file, test_file[:tempfile].path)
  end

  it "should generate resized files when media is an image" do
    @media = MediaRocket::MediaFile.new :file => test_file
    @media.save
    
    MediaRocket::AssociatedFile.all.size.should > 0
    @media.is_image?.should == true
    @media.files.size.should == 2
    @media.associated_to.size.should == 0
    
    associate = @media.files.first
    associated_to = associate.associated_to
    associated_to.size.should == 1
    associated_to.first.path.should == @media.path
  end
  
  it "should have same site and category as associated_to media" do
    @media = MediaRocket::MediaFile.new :file => test_file, 
                                    :site => "domain.com",
                                    :category => "vacances"
    @media.save
    
    @media.files.each do |media|
      media.site.name.should == @media.site.name
      media.category.name.should == @media.category.name
    end
  end
  
  it "should recognize original file" do
     @media = MediaRocket::MediaFile.new :file => test_file
     @media.save

     @media.original?.should be(true)
     @media.files.each do |media|
       media.original?.should be(false)
     end
   end
end