$(document).ready(function() {

	// Validate upload form
	$("#uploadForm").validate({
		rules: {
			media_file: {
				required: true,
				accept: "jpg|jpeg|png|gif|bmp|tif|tiff|ai|pdf"
			}
		}
	});

	// Add category
	$(".category_add").click(function() {
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

	// Add alert when modifications on media-info form
	$('.media-info').ajaxForm(function() { 
		alert("Modifications enregistrees");
		return false;
	});

	// Reload pages when adding a sub-category
	$('.add-category').ajaxForm(function() { 
		location.reload();
	});

	// Make photos boxs draggable
	$("#organize").treeTable();

	$("#organize .media").draggable({
		helper: "clone",
		opacity: .75,
		refreshPositions: true, // Performance?
		revert: "invalid",
		revertDuration: 300,
		scroll: true
	});
	
	$('.expander').click(function(){
		if($(this.nextElementSibling).hasClass("media")){
			viewer_id = "#viewer-" + $(this).parents("tr")[0].id;
			viewer = $($(this).parents("tbody")[0]).find(viewer_id);
			content_url = $(this.nextElementSibling).children("a.show")[0].rel;
			
			if(!viewer.hasClass("loaded")){
				viewer.load(content_url);
				viewer.addClass("loaded");
			}
		}
	});

	$("#organize .category").each(function() {
		$($(this).parents("tr")[0]).droppable({
			accept: ".media",
			drop: function(e, ui) { 
				$($(ui.draggable).parents("tr")[0]).appendBranchTo(this);
				
				// Correct bug when parent doesn't have class
				//if(!$(this).hasClass("collapsed")) {
		        //	$(this).addClass("parent");
				// Append expander
		      	//}

				// Send request to modify media category
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
				$($(ui.draggable).parents("tr")[0]).insertBefore(this);
				// Send request to modify media position
				$.get($(ui.draggable.context).children("a.edit")[0].rel, { position: e.target.id.split("-")[1] });
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



});

