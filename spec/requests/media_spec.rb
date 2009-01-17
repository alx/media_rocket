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
      new_description = <<-EOS
        Lorem Ipsum is simply dummy text of the printing and typesetting industry.
        Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,
        when an unknown printer took a galley of type and scrambled it to make a type
        specimen book. It has survived not only five centuries, but also the leap into
        electronic typesetting, remaining essentially unchanged. It was popularised in
        the 1960s with the release of Letraset sheets containing Lorem Ipsum passages,
        and more recently with desktop publishing software like Aldus PageMaker
        including versions of Lorem Ipsum.
        EOS
      
      @response = request(url(:edit_media_rocket_media, @media), :params => {:description => new_description})
      @response.should be_successful
      
      MediaRocket::MediaFile.first.description.should == new_description
    end
  end
end