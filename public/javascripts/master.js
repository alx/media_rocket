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
});

