$(document).ready(function() {
	// Control remote links, like delete button
  	$("a.remote").click(function() {
		if(this.rel) $(this.rel).load(this.href);
		else $.get(this.href);
		return false;
  	})

	// Add alert when modifications on media-info form
	$('.media-info').ajaxForm(function() { 
		alert("Modifications enregistrees"); 
	});
	
	// Reload pages when adding a sub-category
	$('.add-category').ajaxForm(function() { 
		location.reload();
	});
	
	// Make photos boxs draggable
	$("#organize").treeTable();
	// Configure draggable nodes
	$("#organize .media, #organize .category").draggable({
	  helper: "clone",
	  opacity: .75,
	  refreshPositions: true, // Performance?
	  revert: "invalid",
	  revertDuration: 300,
	  scroll: true
	});

	// Configure droppable rows
	$("#organize .category").each(function() {
	  $(this).parents("tr").droppable({
	    accept: ".media, .category",
	    drop: function(e, ui) { 
	      // Call jQuery treeTable plugin to move the branch
	      $($(ui.draggable).parents("tr")).appendBranchTo(this);
	    },
	    hoverClass: "accept",
	    over: function(e, ui) {
	      // Make the droppable branch expand when a draggable node is moved over it.
	      if(this.id != ui.draggable.parents("tr")[0].id && !$(this).is(".expanded")) {
	        $(this).expand();
	      }
	    }
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

