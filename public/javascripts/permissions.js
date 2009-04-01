$(document).ready(function() {
	// =====
	//
	// Permissions
	//
	// =====
	
	$("a.remove_user").livequery('click', function(event) {
		
		// Fetch user_id
		user = this.rel.split("_").pop();
		
		// query on permission url with "remove_user" action
		$.post("/permissions", { permission_act: "rem_user", user_id: user } );
		
		// remove user from screen
		$("#"+this.rel).hide();
		
		return false;
	});
	
	$("a.add_perm").livequery('click', function(event) {
		
		// Fetching rel info
		rel = this.rel.split("_");
		// Fetch user_id
		user = rel.pop();
		// Fetch gallery_id
		gallery = rel.pop();
		
		// query on permission url with "add_perm" action
		$.post("/permissions", { permission_act: "add_perm", user_id: user, gallery_id: gallery } );
		
		return false;
	});
	
	$("a.remove_perm").livequery('click', function(event) {
		
		// Fetch perm_id
		perm = this.rel.split("_").pop();
		
		// query on permission url with "remove_perm" action
		$.post("/permissions", { permission_act: "rem_perm", perm_id: perm } );
		
		// remove permission from screen
		$("#"+this.rel).hide();
		
		return false;
	});
});

