$(document).ready(function() {
	
// ========================================
// Items manipulation
	
	// ----------------------------------------
	// Create item from json source
	
	function load_item(type, item){
		var loaded_item = "<li id='" + type + "-item-" + item.id + "' class='item " + type + "-item ui-widget-content ui-corner-tr'>";
		
		if(type == 'gallery') {
			loaded_item += "<p style='display: none' class='" + type + "-delete' id='" + type + "-item-delete-" + item.id + "'><a class='ui-icon ui-icon-circle-close'></a></p>"
		}
		
		loaded_item += "<img src='" + item.icon + "' /><br/><a class='item-title'>" + (item.name || "&nbsp;") + "</a></li>";
		return loaded_item;
	}
	
	function load_gallery_item(item) {
		return load_item('gallery', item);
	}
	
	
	function load_media_item(item) {
		return load_item('media', item);
	}
	
	// ----------------------------------------
	// Create temporary item before upload
	
	function temp_item(type){
		var temp_item = "<li id='" + type + "-item-temp' class='item " + type + "-item item-temp ui-widget-content ui-corner-tr'>";
		temp_item += "<img src='images/media_icon'/><br/><a class='item-title'>...</a></li>";
		return temp_item;
	}
	
	function temp_gallery_item() {
		return temp_item('gallery');
	}
	
	function temp_media_item() {
		return temp_item('media');
	}
	
	// ----------------------------------------
	// Replace temporary item if upload successful
	
	function replace_temp_item(type, new_item) {
		var temp_item = $('#' + type + '-item-temp');
		temp_item.attr('id', type + '-item-' + new_item.id);
		temp_item.find('img').attr('src', new_item.icon);
		temp_item.find('span.title').html(new_item.title);
	}
	
	function replace_temp_gallery(item) {
		replace_temp_item('gallery', item);
	}
	
	function replace_temp_media(item) {
		replace_temp_item('media', item);
	}
	
	// ----------------------------------------
	// Remove temporary items
	
	function clean_temp_item() {
		$('.item-temp').remove();
	}
	
// ========================================
// Loading features for main area and tabs

	function load_gallery_details(gallery) {
		$('#action-media-details').hide();
		var gallery_details_div = $('#action-gallery-details');
		
		gallery_details_div.find('#details-gallery-name').val(gallery.name);
		gallery_details_div.find('#details-gallery-ref-title').val(gallery.ref_title);
		gallery_details_div.find('#details-gallery-description').val(gallery.description);
		gallery_details_div.find('#details-gallery-ref_meta').val(gallery.ref_meta);
		
		gallery_details_div.find('#details-gallery-icon img').attr('src', gallery.icon);
		gallery_details_div.find('#details-gallery-icon img').attr('alt', gallery.id);
		
		gallery_details_div.find('#details-gallery-icon img').droppable({
			drop: function(event, ui){
				
				// Create icon from draggable informations
				media = ui.draggable[0];
				icon = {id: media.id.split('-').pop(),
						src: $(media).find('img').attr('src')};
			
				// Create gallery
				gallery_info = { header_icon: icon.id,
						   		 id: media.parentNode.id.split('-').pop()}
						
				// Send new header icon
				$.post("/gallery-update/" + gallery_info.id,
					   {'gallery[header_icon]': [gallery_info.header_icon], method: "_put"});
				
				// Update icon display
				$(this).attr('src', icon.src);
				
				// Stop propagation (do not display media details)
				event.stopPropagation();
				$('#main-area-gallery-' + gallery_info.id).sortable( 'refreshPositions' );
			}
		})
		
		// Change form url
		// url pattern: /prefix/galleries/1/edit
		current_action = $('#gallery-details').attr('action');
		$('#gallery-details').attr('action', current_action.replace(/\⁄\d+\⁄/, '/' + gallery.id + '/'));
		
		gallery_details_div.show();
	}
	
	function load_media_details(media) {
		$('#action-gallery-details').hide();
		var media_details_div = $('#action-media-details');
		
		media_details_div.find('#details-media-name').val(media.name);
		media_details_div.find('#details-media-url').attr('href', media.icon);
		media_details_div.find('#details-media-url').html(media.icon);
		
		// Change form url
		// url pattern: /prefix/galleries/1/edit
		current_action = $('#media-details').attr('action');
		$('#media-details').attr('action', current_action.replace(/\⁄\d+\⁄/, '/' + media.id + '/'));
		
		media_details_div.show();
	}
	
	// Load main-loading interface
	function load_gallery(gallery) {
		
		// Show loading state
		$('#main-area > ul:visible').hide();
		$('#main-area-loading').show();
		
		var json_url = "/galleries.json";
		var div_area = "main-area-galleries";
		
		// gallery specified, load json corresponding to this gallery
		if(gallery) {
			json_url = "/gallery/" + gallery.id + ".json";
			div_area = "main-area-gallery-" + gallery.id;
		}
		
		// Append new div area if not already exists
		if(!$('#' + div_area).length) {
			$('#main-area').append("<ul id='" + div_area + "' class='gallery-area ui-helper-reset ui-helper-clearfix' style='display: none'/>");
			$("#" + div_area).disableSelection();
		}
			
		$.getJSON(json_url, function(json) {

			if(json.galleries){
				$.each(json.galleries,function(i,item) {
					$('#' + div_area).append(load_gallery_item(item));
				});
			}
			
			if(json.medias){
				$.each(json.medias,function(i,item) {
					$('#' + div_area).append(load_media_item(item));
				});
			}
			
			if(json.gallery)
				load_gallery_details(json.gallery);
			
			$("#" + div_area).sortable({ 
				items: 'li.media-item',
				update: function(event, ui) {
					
					// Create gallery url
					gallery_url = "/gallery-update/" + this.id.split('-').pop();
					
					// retrieve new order list
					var ordered_list = $(this).sortable('serialize');
					
					// Replace value for request format
					ordered_list = ordered_list.replace(/media-item\[\]=/g,'');
					ordered_list = ordered_list.replace(/&/g,',');
					
					// send the new order to server
					$.post(gallery_url, {media_list: ordered_list, method: "_put"});
				}
			});
			$('#' + div_area).show();
		});
		
		// Show current gallery
		$('#main-area-loading').hide();
	}
	
	function display_add_gallery_name(gallery){
		if (gallery){
			// Display specific gallery, 
			// set parent_id and gallery name for "add gallery" form
			$('input#gallery-parent').attr('value', gallery.id);
			$('input.gallery-id').attr('value', gallery.id);
			
			$('span#gallery-parent-name').text(gallery.name);
			$('span#gallery-parent-name').parent('p').show();
			
			// Display upload forms
			if($('#action-upload-solo').attr('style') == "display: none;") {
				$('#action-upload-solo').show('slide');
				$('#action-upload-multi').show('slide');
			}
			
			if($('#action-gallery-details').attr('style') == "display: none;")
				load_gallery_details(gallery)
			
		} else {
			// Display main gallery
			// Hide upload forms
			if($('#action-upload-solo').attr('style') != "display: none;") {
				$('#action-upload-solo').hide('slide');
				$('#action-upload-multi').hide('slide');
			}
			
			// Update gallery id attributes
			$('input#gallery-parent').attr('value', '');
			$('input.gallery-id').attr('value', '');
			
			// Hide gallery name
			$('span#gallery-parent-name').parent('p').hide();
			
			// Hide details
			$('#action-gallery-details').hide();
			$('#action-media-details').hide();
		}
	}
	
	function add_or_display_tab(gallery) {
		
		// Load new tabs if not already present
		if(!$('#gallery-tab-' + gallery.id).length) {
			
			$('#tabs').tabs('add', gallery.id.toString(), gallery.name);
			
			// Load medias in tab
			load_gallery(gallery);
			
		} else {
			$('#main-area > ul').hide();
			$('#main-area-gallery-' + gallery.id).show();
		}
		
		// Display galleryname and set parent_id
		display_add_gallery_name(gallery);
		
		$('#tabs li').removeClass('ui-tabs-selected');
		$('#gallery-tab-' + gallery.id).parent('li').addClass('ui-tabs-selected');
		$("#tabs").tabs('select', 'gallery-tab-' + gallery.id);
	}
	
// ========================================
// Ajax Form
	
    $('#gallery-add').ajaxForm({
		dataType:  'json',
		beforeSubmit: function(){
			// Display temporary gallery in main area displayed div
			$('#main-area > ul').append(temp_gallery_item());
		},
		success: function(data){
			var gallery = data.galleries[0];
			
			if(gallery) {
				$('#main-area > ul').append(replace_temp_gallery(gallery));
				add_or_display_tab(gallery);
				$("input#gallery-name").attr("value", "");
			} else {
				// TODO: display error message
				clean_temp_item();
			}
		}
    });

    $('#media-solo-form').ajaxForm({
		dataType:  'json',
		beforeSubmit: function(){
			// Display temporary gallery in main area displayed div
			$('#main-area > ul').append(temp_media_item());
			
			// Remove media name if not specified
			if($('#title-field').attr('value') == $('#title-field').attr('title')){
				$('#title-field').attr('value', '');
			}
		},
		success: function(data){
			var media = data.media;
			
			if(media){
				// Display result gallery in main area displayed div
				$('#main-area > ul').append(replace_temp_media(media));
				
				// Re-init form
				$('input#title-field').attr('value', $('#title-field').attr('title'));
				$('input#media_file').attr('value', '')
			} else {
				// TODO: display error message
				clean_temp_item();
			}
		}
    });

	$('#gallery-details').ajaxForm({
		dataType:  'json',
		beforeSubmit: function(){
		},
		success: function(data){
			// Replace tab name
		}
	});
	
	$('#media-details').ajaxForm({
		dataType:  'json',
		beforeSubmit: function(){
		},
		success: function(data){
		}
	});
	
	// ----------------------------------------
	// Input customization
	
	// erasable class is an input containing default text
	$('.erasable').focus( function() {
		$(this).attr('value', '');
		$(this).removeClass('erasable');
	});
	
	$('.erasable').blur( function() {
		if (!$(this).attr('value')){
			$(this).attr('value', this.title);
			$(this).addClass('erasable');
		}
	});
	

// ========================================
// Actions on DOM
	
	$(".gallery-delete a").livequery('click', function() {
		var gallery_id = $(this).parent('p').get(0).id.split('-').pop();
		$.post('/galleries/delete/'+ gallery_id);
		$(this).parent('ul').remove();
	});
	
	$(".gallery-item").livequery('click', function() {
		add_or_display_tab({id: this.id.split('-').pop(), 
							name: $(this).find('.item-title').html()});
	});
	
	$(".media-item").livequery('dblclick', function() {
		load_media_details({id: this.id.split('-').pop(), 
							name: $(this).find('.item-title').html(), 
							url: $(this).find('img').attr('src')});
	});
	
	$("a.gallery-tab").livequery('click', function() {
		var gallery_id = this.id.split('-').pop();
		// gallery name is in second span (first span is closing icon)
		var gallery_name = $(this).children('span').get(1).innerHTML;
		add_or_display_tab({id: gallery_id, name: gallery_name});
	});
	
	$("a#galleries-tab").livequery('click', function() {
		$('#main-area > ul').hide();
		$('#main-area-galleries').show();
		
		$('#tabs li').removeClass('ui-tabs-selected');
		$(this).parent('li').addClass('ui-tabs-selected');
		$("#tabs").tabs('select', 'galleries-tab');
		
		// hide galleryname and set parent_id
		display_add_gallery_name();
	});
	
	$(".media-item").livequery('click', function(event) {
		// Display thickbox corresponding to selected item
	});
	
	$('.item').livequery('mouseover', function(event) {
		$(this).find('.gallery-delete').show();
	});
	
	$('.item').livequery('mouseout', function(event) {
		$(this).find('.gallery-delete').hide();
	});
	
	$(".gallery-item .close-tab").livequery('click', function(event) {
		var gallery_id = this.id.split('-').pop();
		
		// empty div used by selected tab
		$('#main-area-gallery-' + gallery_id).remove();
		$('#main-area-gallery-' + gallery_id).sortable('remove');
		
		// remove corresponding tabs
		$('#gallery-tab-' + gallery_id).remove();
		
		// return to main gallery
		$('#main-area > ul').hide();
		$('#main-area-galleries').show();

		$('#tabs li').removeClass('ui-tabs-selected');
		$("a#galleries-tab").parent('li').addClass('ui-tabs-selected');
		$("#tabs").tabs('select', 'galleries-tab');
	});
	
// ========================================
// Init Script
	
	// ----------------------------------------
	// Header Tabs
	//
	// panelTemplate: do not display panel template,
	//				  we're using our own panel to display galleries content
	//
	// tabTemplate: Customize tabTemplate to include gallery.id and add an icon to close the gallery
	//
	$("#tabs").tabs({
		panelTemplate: '<div style="display: none"></div>',
		tabTemplate: '<li><a id="gallery-tab-#{href}" class="gallery-tab"><span id="close-tab-#{href}" class="ui-icon ui-icon-close close-tab" /><span>#{label}</span></a></li>'
	});
	
	// ----------------------------------------
	// Left panel accordeon for user actions

	$("#accordion").accordion();

	// ----------------------------------------
	// Init page: Load main gallery and select galleries-tab

	load_gallery();
	$("#tabs").tabs('select', 'galleries-tab');

});

