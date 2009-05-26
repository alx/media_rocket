module MediaRocket
  module Helpers
    module Content
      
      def gallery_tabs
        "<div id='tabs'>
        	<ul>
        		<li class='ui-state-default ui-corner-top ui-tabs-selected'><a id='galleries-tab'><span>Galleries</span></a></li>
        	</ul>
        </div>"
      end
      
      def action_gallery_details
        "<div id='action-gallery-details' style='display: none' class='ui-helper-reset ui-widget-content ui-corner-all'>

    			<h3>Gallery Details</h3>

    			<span id='details-gallery-icon'><img src='' alt=''/></span>

    			<form id='gallery-details'>

    				<input type='hidden' value='' id='details-gallery-id'/>
    				
    				<p>
    					<label for='gallery[name]'>Gallery Name</label><br/>
    					<input type='text' name='gallery[name]' value='' id='details-gallery-name'/>
    				</p>

    				<h4>SEO</h4>
    				<p>	
    					<label for='gallery[ref_title]'>Title</label><br/>
    					<input type='text' name='gallery[ref_title]' value='' id='details-gallery-ref-title'/><br/>

    					<label for='gallery[description]'>Description</label><br/>
    					<input type='text' name='gallery[description]' value='' id='details-gallery-description'/><br/>

    					<label for='gallery[ref_meta]'>Meta Keywords</label><br/>
    					<input type='text' name='gallery[ref_meta]' value='' id='details-gallery-ref-meta'/>
    				</p>

    				<p><input type='submit' value='Modify &rarr;'></p>
    			</form>
    		</div>"
  		end
  		
  		def action_media_details
  		  "<div id='action-media-details' style='display: none' class='ui-helper-reset ui-widget-content ui-corner-all'>
    			<h3>Media Details</h3>

    			<span id='details-media-close' class='ui-icon ui-icon-circle-close'></span>

    			<input type='hidden' value='' id='details-media-id'/>

    			<form id='media-details'>
    				<p>
    					<label for='media[title]'>Media Name</label><br/>
    					<input type='text' name='media[title]' value='' id='details-media-name'><br/>
    					
    					<label for='media[description]'>Description</label><br/>
    					<input type='text' name='media[description]' value='' id='details-media-description'/>
    				</p>

    				<p>
    					<label>Media Url</label><br/>
    					<a href='#' id='details-media-url'>&nbsp;</a>
    				</p>

    				<p><input type='submit' value='Modify &rarr;'></p>
    			</form>
    		</div>"
  		end
  		
  		def action_accordion
  		  "<div id='accordion'>
    			<h3 id='action-add-gallery'><a href='#'>Add Gallery</a></h3>
    			<div>
    				<form action='#{url(:media_rocket_galleries)}' method='post' accept-charset='utf-8' id='gallery-add'>
    					<p><label for='name'>Gallery Name</label><br/>
    					<input type='text' name='gallery[name]' value='' id='gallery-name'></p>
    					<input type='hidden' name='gallery[parent_id]' value='' id='gallery-parent'>
    					<input type='hidden' name='gallery[site_id]' value='#{MediaRocket::Site.first.id}' id='gallery-site'>
    					<p><input type='submit' value='Continue &rarr;'></p>
    				</form>
    				<p style='display: none'>Inside gallery: <span id='gallery-parent-name'></span></p>
    			</div>

    			<h3 id='action-upload-solo' style='display: none'><a href='#'>Upload One</a></h3>
    			<div>
    				#{media_upload_form :format => 'flat'}
    			</div>

    			<h3 id='action-upload-multi' style='display: none'><a href='#'>Upload Multi</a></h3>
    			<div>
    				#{media_upload_form :format => 'uploadify'}
    			</div>
    		</div>"
  		end
  		
    	def main_action
    	  "<div id='main-action' class='span-8'>" <<
    	    action_gallery_details <<
    	    action_media_details << 
    	    action_accordion <<
    	  "</div>"
  	  end
  		
  		def main_area
  		  "<div id='main-area' class='span-16 last ui-widget ui-helper-clearfix'>
      		<span id='main-area-loading'>
      			Loading...
      		</span>
      	</div>"
    	end
    	
      def gallery_organize(options = {}, &block)
        "<div id='organize' class='span-24'>" <<
          main_action <<
          main_area <<
        "</div>"
      end
      
      def media_rocket_organize
        gallery_tabs << gallery_organize
      end
    end
  end
end