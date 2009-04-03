$(document).ready(function() {

	// Validate upload form
	$("#uploadForm").validate({
		rules: {
			media_file: {
				required: true,
				accept: "jpg|jpeg|png|gif|bmp|tif|tiff|ai|pdf|mp3"
			}
		}
	});

	// Add gallery
	$(".gallery_add").click(function() {
		this.value = "";
	})

	// Control remote links, like delete button
	$("a.remote").click(function() {
		if(this.rel) $(this.rel).load(this.href);
		else $.get(this.href);
		return false;
	})

	$('a.delete').confirm({
		timeout:3000,
		dialogShow:'fadeIn',
		dialogSpeed:'slow',
		buttons: {
			wrapper:'<button></button>',
			separator:'  '
		}  
	});

	// Add alert when modifications on liveform
	$('.liveform').livequery(function(){
		$('.liveform').ajaxForm(function() { 
			alert("Modifications enregistrees");
			tb_remove();
		});
		return false;
	});

	// Reload pages when adding a sub-gallery
	$('.add-gallery').ajaxForm(function() { 
		location.reload();
	});

	// Make photos boxs draggable
	$("#organize").treeTable();

	$("#organize .media").draggable({
		cursor: 'move',
		helper: "clone",
		opacity: .75,
		refreshPositions: true, // Performance?
		revert: "invalid",
		revertDuration: 800,
		scroll: true
	});
	
	$('.expander').click(function(){
		if($(this.nextSibling).hasClass("media")){
			viewer_id = "#viewer-" + $(this).parents("tr")[0].id;
			viewer = $($(this).parents("tbody")[0]).find(viewer_id);
			content_url = $(this.nextSibling).children("a.show")[0].rel;
			
			if(!viewer.hasClass("loaded")){
				viewer.load(content_url);
				viewer.addClass("loaded");
			}
		}
	});

	$("#organize .gallery").each(function() {
		$($(this).parents("tr")[0]).droppable({
			accept: ".media",
			drop: function(e, ui) { 
				$($(ui.draggable).parents("tr")[0]).appendBranchTo(this);
				
				// Correct bug when parent doesn't have class
				//if(!$(this).hasClass("collapsed")) {
		        //	$(this).addClass("parent");
				// Append expander
		      	//}

				// Send request to modify media gallery
				$.get($(ui.draggable.context).children("a.edit")[0].rel, { gallery_id: e.target.id.split("-")[1] });
			},
			hoverClass: "accept",
			over: function(e, ui) {
				if(this.id != ui.draggable.parents("tr")[0].id && !$(this).is(".expanded")) {
					$(this).expand();
				}
			}
		});
	});
	
	$("#organize .media").each(function() {
		$($(this).parents("tr")[0]).droppable({
			accept: ".media",
			drop: function(e, ui) {
				selected_media = $(ui.draggable).parents("tr")[0];
				media_viewer = selected_media.nextSibling;
				$(media_viewer).insertBefore(this);
				$(selected_media).insertBefore(media_viewer);
				
				table_body = $(this).parents("tbody")[0];
				gallery_id = this.className.match(/child-of-gallery-(\d+)/)[1];
				selected_media_gallery_id = selected_media.className.match(/child-of-gallery-(\d+)/)[1];
				
				// Send request to modify media gallery (if media change gallery)
				if(selected_media_gallery_id != gallery_id){
					$.get($(ui.draggable.context).children("a.edit")[0].rel, { gallery_id: gallery_id });
				}
				
				// Send request to modify media position
				gallery_url = $(table_body).find(".gallery a.edit")[0].rel;
				var media_list = selected_media.id.split("-")[1];
				$(table_body).children("tr.child-of-gallery-" + gallery_id).each(function(){
					media_list += "," + this.id.split("-")[1];
				});
				$.get(gallery_url, { media_list: media_list });
			},
			hoverClass: "media_over"
		});
	});

	// Make visible that a row is clicked
	$("table#organize tbody tr").mousedown(function() {
		$("tr.selected").removeClass("selected"); // Deselect currently selected rows
		$(this).addClass("selected");
	});

	// Make sure row is selected when span is clicked
	$("table#organize tbody tr span").mousedown(function() {
		$($(this).parents("tr")[0]).trigger("mousedown");
	});
	
	$('.media-row').hover(function(e) {
		$(e.target).parent('tr').find('.drag').removeClass('hidden');
	}, function(e) {
   		$(e.target).parent('tr').find('.drag').addClass('hidden');
	});

   

});

