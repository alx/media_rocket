$(document).ready(function() {
	
	// =======
	//
	// Slick interface
	//
	// =======
	
	function display_add_gallery_name(gallery){
		if (gallery){
			// Display specific gallery, 
			// set parent_id and gallery name for "add gallery" form
			$('input#gallery-parent').attr('value', gallery.id);
			$('span#gallery-parent-name').parent('p').removeClass('hidden');
			$('span#gallery-parent-name').text(gallery.name);
			
			// Display upload forms
			$('#action-upload-solo').show('slide');
			$('#action-upload-multi').show('slide');
			$('input.gallery[id]').attr('value', gallery.id);
		} else {
			// Hide upload forms
			$('#action-upload-solo').hide('slide');
			$('#action-upload-multi').hide('slide');
			$('input.gallery[id]').attr('value', gallery.id);
			
			// Display main gallery
			$('input#gallery-parent').attr('value', '');
			$('input.gallery[id]').attr('value', '');
			$('span#gallery-parent-name').parent('p').addClass('hidden');
		}
	}
	
	function load_gallery_item(item) {
		var gallery_item = "<div id='gallery-item-" + item.id + "' class='item gallery-item ui-corner-all'>";
		gallery_item += "<p class='gallery-delete' id='gallery-item-delete-" + item.id + "'><a class='ui-icon ui-icon-circle-close'></a></p>"
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
	
	$(".gallery-delete a").livequery('click', function() {
	var gallery_id = $(this).parent('p').get(0).id.split('-').pop();
	$.post('/galleries/delete/'+ gallery_id);
	$(this).parent('p').parent('div').remove();
	});
	
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
	
	// === Init script ===
	
	// Add header tabs
	$("#tabs").tabs({
		panelTemplate: '<div class="hidden"></div>',
		tabTemplate: '<li><a id="gallery-tab-#{href}" class="gallery-tab"><span id="close-tab-#{href}" class="ui-icon ui-icon-close close-tab" /><span>#{label}</span></a></li>'
	});
	
	// Use accordion on main actions
	$("#main-action").accordion();
	
	// Load main gallery
	load_gallery();
	$("#tabs").tabs('select', 'galleries-tab');
	
	// // =======
	// //
	// // Old interface
	// //
	// // =======
	// 
	// // Add tabs on file upload
	// $("#tabs").tabs();
	// 
	// // Validate upload form
	// $("#uploadForm").validate({
	// 	rules: {
	// 		media_file: {
	// 			required: true,
	// 			accept: "jpg|jpeg|png|gif|bmp|tif|tiff|ai|pdf|mp3"
	// 		}
	// 	}
	// });
	// 
	// // Add gallery
	// $(".gallery_add").click(function() {
	// 	this.value = "";
	// })
	// 
	// // Control remote links, like delete button
	// $("a.remote").click(function() {
	// 	if(this.rel) $(this.rel).load(this.href);
	// 	else $.get(this.href);
	// 	return false;
	// })
	// 
	// $('a.delete').confirm({
	// 	timeout:3000,
	// 	dialogShow:'fadeIn',
	// 	dialogSpeed:'slow',
	// 	buttons: {
	// 		wrapper:'<button></button>',
	// 		separator:'  '
	// 	}  
	// });
	// 
	// // Add alert when modifications on liveform
	// $('.liveform').livequery(function(){
	// 	$('.liveform').ajaxForm(function() { 
	// 		alert("Modifications enregistrees");
	// 		tb_remove();
	// 	});
	// 	return false;
	// });
	// 
	// // Reload pages when adding a sub-gallery
	// $('.add-gallery').ajaxForm(function() { 
	// 	location.reload();
	// });
	// 
	// // Make photos boxs draggable
	// $("#organize").treeTable();
	// 
	// $("#organize .media").draggable({
	// 	cursor: 'move',
	// 	helper: "clone",
	// 	opacity: .75,
	// 	refreshPositions: true, // Performance?
	// 	revert: "invalid",
	// 	revertDuration: 800,
	// 	scroll: true
	// });
	// 
	// $('.expander').click(function(){
	// 	if($(this.nextSibling).hasClass("media")){
	// 		viewer_id = "#viewer-" + $(this).parents("tr")[0].id;
	// 		viewer = $($(this).parents("tbody")[0]).find(viewer_id);
	// 		content_url = $(this.nextSibling).children("a.show")[0].rel;
	// 		
	// 		if(!viewer.hasClass("loaded")){
	// 			viewer.load(content_url);
	// 			viewer.addClass("loaded");
	// 		}
	// 	}
	// });
	// 
	// $("#organize .gallery").each(function() {
	// 	$($(this).parents("tr")[0]).droppable({
	// 		accept: ".media",
	// 		drop: function(e, ui) { 
	// 			$($(ui.draggable).parents("tr")[0]).appendBranchTo(this);
	// 			
	// 			// Correct bug when parent doesn't have class
	// 			//if(!$(this).hasClass("collapsed")) {
	// 	        //	$(this).addClass("parent");
	// 			// Append expander
	// 	      	//}
	// 
	// 			// Send request to modify media gallery
	// 			$.get($(ui.draggable.context).children("a.edit")[0].rel, { gallery_id: e.target.id.split("-")[1] });
	// 		},
	// 		hoverClass: "accept",
	// 		over: function(e, ui) {
	// 			if(this.id != ui.draggable.parents("tr")[0].id && !$(this).is(".expanded")) {
	// 				$(this).expand();
	// 			}
	// 		}
	// 	});
	// });
	// 
	// $("#organize .media").each(function() {
	// 	$($(this).parents("tr")[0]).droppable({
	// 		accept: ".media",
	// 		drop: function(e, ui) {
	// 			selected_media = $(ui.draggable).parents("tr")[0];
	// 			media_viewer = selected_media.nextSibling;
	// 			$(media_viewer).insertBefore(this);
	// 			$(selected_media).insertBefore(media_viewer);
	// 			
	// 			table_body = $(this).parents("tbody")[0];
	// 			gallery_id = this.className.match(/child-of-gallery-(\d+)/)[1];
	// 			selected_media_gallery_id = selected_media.className.match(/child-of-gallery-(\d+)/)[1];
	// 			
	// 			// Send request to modify media gallery (if media change gallery)
	// 			if(selected_media_gallery_id != gallery_id){
	// 				$.get($(ui.draggable.context).children("a.edit")[0].rel, { gallery_id: gallery_id });
	// 			}
	// 			
	// 			// Send request to modify media position
	// 			gallery_url = $(table_body).find(".gallery a.edit")[0].rel;
	// 			var media_list = selected_media.id.split("-")[1];
	// 			$(table_body).children("tr.child-of-gallery-" + gallery_id).each(function(){
	// 				media_list += "," + this.id.split("-")[1];
	// 			});
	// 			$.get(gallery_url, { media_list: media_list });
	// 		},
	// 		hoverClass: "media_over"
	// 	});
	// });
	// 
	// // Make visible that a row is clicked
	// $("table#organize tbody tr").mousedown(function() {
	// 	$("tr.selected").removeClass("selected"); // Deselect currently selected rows
	// 	$(this).addClass("selected");
	// });
	// 
	// // Make sure row is selected when span is clicked
	// $("table#organize tbody tr span").mousedown(function() {
	// 	$($(this).parents("tr")[0]).trigger("mousedown");
	// });
	// 
	// $('.media-row').hover(function(e) {
	// 	$(e.target).parent('tr').find('.drag').removeClass('hidden');
	// }, function(e) {
	//    		$(e.target).parent('tr').find('.drag').addClass('hidden');
	// });
	// 
	// // Media icon for gallery header
	// $("a.icon-media-selector").click( function() {
	// 	
	// 	info = this.rel.split("-");
	// 	gallery_id = info.pop();
	// 	info.pop();
	// 	media_id = info.pop();
	// 	
	// 	// Hide all header-icon
	// 	$('img.icon-media-header.gallery_'+gallery_id).addClass("hidden");
	// 	// Show all selector-icon
	// 	$('a.icon-media-selector.gallery_'+gallery_id).removeClass("hidden");
	// 	
	// 	var data = '_method=PUT&id=' + gallery_id + '&gallery[header_icon]=' + media_id;
	// 	$.post("/library/gallery_icon", data );
	// 	
	// 	$('a#icon-media-selector-' + media_id).addClass("hidden");
	// 	$('img#icon-media-header-' + media_id).removeClass("hidden");
	// 	
	// });
});

