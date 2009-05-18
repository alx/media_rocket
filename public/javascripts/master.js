$(document).ready(function() {
	
	function display_add_gallery_name(gallery){
		if (gallery){
			// Display specific gallery, 
			// set parent_id and gallery name for "add gallery" form
			$('input#gallery-parent').attr('value', gallery.id);
			$('input.gallery-id').attr('value', gallery.id);
			
			$('span#gallery-parent-name').parent('p').removeClass('hidden');
			$('span#gallery-parent-name').text(gallery.name);
			
			// Display upload forms
			if($('#action-upload-solo').attr('style') == "display: none;") {
				$('#action-upload-solo').show('slide');
				$('#action-upload-multi').show('slide');
			}
			
		} else {
			// User want to display main gallery
			
			// Hide upload forms
			if($('#action-upload-solo').attr('style') != "display: none;") {
				$('#action-upload-solo').hide('slide');
				$('#action-upload-multi').hide('slide');
			}
			
			// Update gallery id attributes
			$('input#gallery-parent').attr('value', '');
			$('input.gallery-id').attr('value', '');
			
			// Hide gallery name
			$('span#gallery-parent-name').parent('p').addClass('hidden');
		}
	}
	
	function load_gallery_item(item) {
		var gallery_item = "<div id='gallery-item-" + item.id + "' class='item gallery-item ui-corner-all'>";
		gallery_item += "<img src='" + item.icon + "' /><br/>";
		gallery_item += "<a class='item-title'>" + item.name + "</a>";
		gallery_item += "</div>";
		return gallery_item;
	}
	
	function load_media_item(item) {		
		var media_item = "<div id='media-item-" + item.id + "' class='item media-item ui-corner-all'>";
		media_item += "<img src='" + item.icon + "' /><br/>";
		media_item += "<a class='item-title'>" + item.title + "</a>";
		media_item += "</div>";
		return media_item;
	}
	
	// Load main-loading interface
	function load_gallery(gallery) {
		
		var json_url = "/galleries.json";
		var div_area = "main-area-galleries";
		
		// gallery specified, load json corresponding to this gallery
		if(gallery) {
			json_url = "/gallery/" + gallery.id + ".json";
			div_area = "main-area-gallery-" + gallery.id;
		}
		
		// Append new div area if not already exists
		if(!$('#' + div_area).length) {
			$('#main-area').append("<div id='" + div_area + "' class='hidden'/>");
		}
			
		$.getJSON(json_url, function(json) {
			
			// Show loading state
			$('#main-area > div').addClass('hidden');
			$('#main-area-loading').removeClass('hidden');

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
			
			// Show current gallery
			$('#main-area-loading').addClass('hidden');
			$('#' + div_area).removeClass('hidden');
			
		});
	}
	
	function add_or_display_tab(gallery) {
		
		// Load new tabs if not already present
		if(!$('#gallery-tab-' + gallery.id).length) {
			
			$('#tabs').tabs('add', gallery.id.toString(), gallery.name);
			
			// Load medias in tab
			load_gallery(gallery);
			
		} else {
			$('#main-area > div').addClass('hidden');
			$('#main-area-gallery-' + gallery.id).removeClass('hidden');
		}
		
		// Display galleryname and set parent_id
		display_add_gallery_name(gallery);
		
		$('#tabs li').removeClass('ui-tabs-selected');
		$('#gallery-tab-' + gallery.id).parent('li').addClass('ui-tabs-selected');
		$("#tabs").tabs('select', 'gallery-tab-' + gallery.id);
	}
	
	$("div.gallery-item").livequery('click', function() {
		var gallery_id = this.id.split('-').pop();
		var gallery_name = $('#gallery-item-' + gallery_id + ' > a').get(0).innerHTML;
		add_or_display_tab({id: gallery_id, name: gallery_name});
	});
	
	$("a.gallery-tab").livequery('click', function() {
		var gallery_id = this.id.split('-').pop();
		// gallery name is in second span (first span is closing icon)
		var gallery_name = $(this).children('span').get(1).innerHTML;
		add_or_display_tab({id: gallery_id, name: gallery_name});
	});
	
	$("a#galleries-tab").livequery('click', function() {
		$('#main-area > div').addClass('hidden');
		$('#main-area-galleries').removeClass('hidden');
		
		$('#tabs li').removeClass('ui-tabs-selected');
		$(this).parent('li').addClass('ui-tabs-selected');
		$("#tabs").tabs('select', 'galleries-tab');
		
		// hide galleryname and set parent_id
		display_add_gallery_name();
	});
	
	$(".media-item").livequery('click', function(event) {
		// Display thickbox corresponding to selected item
	});
	
	$(".close-tab").livequery('click', function(event) {
		var gallery_id = this.id.split('-').pop();
		
		// empty div used by selected tab
		$('#main-area-gallery-' + gallery_id).remove();
		
		// remove corresponding tabs
		$('#gallery-tab-' + gallery_id).remove();
		
		// return to main gallery
		$('#main-area > div').addClass('hidden');
		$('#main-area-galleries').removeClass('hidden');

		$('#tabs li').removeClass('ui-tabs-selected');
		$("a#galleries-tab").parent('li').addClass('ui-tabs-selected');
		$("#tabs").tabs('select', 'galleries-tab');
	});
	
// ========================================
// Ajax Form
	
    $('#gallery-add').ajaxForm({
		dataType:  'json',
		success: function(data){
			var gallery = data.galleries[0];
			$('#main-area > div').append(load_gallery_item(gallery));
			add_or_display_tab(gallery);
			$("input#gallery-name").attr("value", "");
		}
    });

    $('#media-solo-add').ajaxForm({
		dataType:  'json',
		success: function(data){
			$('#main-area').append(load_media_item(data.medias[0]));
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
		panelTemplate: '<div class="hidden"></div>',
		tabTemplate: '<li><a id="gallery-tab-#{href}" class="gallery-tab"><span id="close-tab-#{href}" class="ui-icon ui-icon-close close-tab" /><span>#{label}</span></a></li>'
	});
	
	// ----------------------------------------
	// Left panel accordeon for user actions

	$("#main-action").accordion();

	// ----------------------------------------
	// Init page: Load main gallery and select galleries-tab

	load_gallery();
	$("#tabs").tabs('select', 'galleries-tab');

});

