require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/medias" do
  
  test_file = {:filename => 'image.png', :tempfile => Tempfile.new('image.png')}
  
  given "a media exists" do
    MediaRocket::MediaFile.all.destroy!
    media = MediaRocket::MediaFile.new :file => test_file
    Merb.logger.info "size: #{MediaRocket::MediaFile.all.size}"
    media.save.should == true
    Merb.logger.info "size: #{MediaRocket::MediaFile.all.size}"
  end
  
  describe "url(:edit_medias, @media)", :given => "a media exists" do
    
    initial_description = "description initiale"
    
    before(:each) do
      Merb.logger.info "media: #{MediaRocket::MediaFile.first.id}"
      @media = MediaRocket::MediaFile.first
      @response = request(url(:edit_media_rocket_media, @media), :params => {:description => initial_description})
    end

    it "responds successfully" do
      @response.should be_successful
      MediaRocket::MediaFile.first.description.should == initial_description
    end
    
    it "changes description" do
      new_description = " description image bout vin et blabla et bloblo "
      
      @response = request(url(:edit_media_rocket_media, @media), :params => {:description => new_description})
      @response.should be_successful
      
      MediaRocket::MediaFile.first.description.should == new_description
    end
  end
end