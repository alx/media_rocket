$(document).ready(function() {
	
	// =======
	//
	// Slick interface
	//
	// =======
	
	function load_gallery_item(item) {
		var gallery_item = "<div id='gallery-item-" + item.id + "' class='item gallery-item ui-corner-all'>";
		gallery_item += "<img src='" + item.icon + "' /><br/>";
		gallery_item += "<a class='item-title'>" + item.name + "</a>";
		gallery_item += "</div>";
		return gallery_item;
	}
	
	function load_media_item(item) {		
		var media_item = "<div id='media-item-" + item.id + "' class='item media-item ui-corner-all'>";
		media_item += "<img src='" + item.icon + "' />";
		media_item += "</div>";
		return media_item;
	}
	
	// Load main-loading interface
	function load_gallery(gallery_id) {
		
		var json_url = "/galleries.json";
		var div_area = "main-area-galleries";
		
		// gallery_id specified, load json corresponding to this gallery
		if(gallery_id != null) {
			json_url = "/gallery/" + gallery_id + ".json";
			div_area = "main-area-gallery-" + gallery_id;
		}
		
		// Append new div area if not already exists
		if($('#' + div_area).length == 0) {
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
		
		$("#tabs").tabs('select', 'gallery-tab-' + gallery_id);
	}
	
	function add_or_display_tab(gallery_id, gallery_name) {
		
		// Load new tabs if not already present
		if($('gallery-tab-' + gallery_id).length == 0) {
			
			$('#tabs').tabs('add', gallery_id, gallery_name);
			
			// Load medias in tab
			load_gallery(gallery_id);
			
		} else {
			$('#main-area > div').addClass('hidden');
			$('#main-area-gallery-' + gallery_id).removeClass('hidden');
		}
	}
	
	$(".gallery-item").click( function() {
		var gallery_id = this.id.split('-').pop();
		var gallery_name = $('#gallery-item-' + gallery_id + ' > a')[0].innerHTML;
		add_or_display_tab(gallery_id, gallery_name);
	});
	
	$(".gallery-tab").click( function() {
		var gallery_id = this.id.split('-').pop();
		add_or_display_tab(gallery_id, '');
	});
	
	$(".galleries-tab").click( function() {
		$('#main-area > div').addClass('hidden');
		$('#main-area-galleries').removeClass('hidden');
	});
	
	$(".media-item").click( function(event) {
		// Display thickbox corresponding to selected item
	});
	
	$(".gallery-tab-close").livequery('click', function(event) {
		// empty div used by selected tab
		// close selected tabs
		// return to main gallery
	});
	
	// === Init script ===
	
	// Add header tabs
	$("#tabs").tabs({
		panelTemplate: '',
		tabTemplate: '<li><a id="gallery-tab-#{href}" class="gallery-tab"><span>#{label}</span></a></li>'
	});
	
	// Use accordion on main actions
	$("#main-action").accordion();
	
	// Load main gallery
	load_gallery();
	
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

