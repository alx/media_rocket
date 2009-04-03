// =====
//
// Permissions library
//
// =====

// post-submit callback 
function showResponse(responseText, statusText)  { 
    // for normal html responses, the first argument to the success callback 
    // is the XMLHttpRequest object's responseText property 
 
    // if the ajaxForm method was passed an Options Object with the dataType 
    // property set to 'xml' then the first argument to the success callback 
    // is the XMLHttpRequest object's responseXML property 
 
    // if the ajaxForm method was passed an Options Object with the dataType 
    // property set to 'json' then the first argument to the success callback 
    // is the json data object returned by the server 
 
    alert('status: ' + statusText + '\n\nresponseText: \n' + responseText + 
        '\n\nThe output div should have already been updated with the responseText.'); 
}

$(document).ready(function() {
	
	// -----
	// Add user form
	//  - Send new user request to add user to DB
	//  - if HTTP return is 200, add the user in the user-list
	// -----
	$('form.userform').livequery(function(){
		$('form.userform').ajaxForm(function() { 
			target: 	'#permission-list',
			success: 	showResponse
		});
		return false;
	});
	
	// -----
	// Remove user by clicking a link
	//  - Remove the user from DB using post request
	//  - Remove the user from the user-list
	// -----
	$("a.remove_user").livequery('click', function(event) {
		
		// Fetch user_id
		user = this.id.split("_").pop();
		
		// query on permission url with "remove_user" action
		$.post("/permissions", { permission_act: "rem_user", user_id: user } );
		
		// remove user from list
		$("#"+this.rel).hide();
		
		return false;
	});
	
	$("input.permission-item").livequery('click', function(event) {
		
		// -----
		// Add permission by checking a checkbox
		//  - fetch user_id and gallery_id from the checbox
		//  - Send request to add a permission on this gallery to this user
		// -----
		if (this.is(':checked')) {
		  	// Fetching rel info
			rel = this.name.split("_");
			// Fetch user_id
			user = rel.pop();
			// Fetch gallery_id
			gallery = rel.pop();

			// query on permission url with "add_perm" action
			$.post("/permissions", { permission_act: "add_perm", user_id: user, gallery_id: gallery } );
		}
		
		// -----
		// Remove permission by unchecking a checkbox
		//  - fetch the permission id from the checkbox
		//  - Send request to destroy this permission
		// -----
		else {
			// Fetch perm_id
			perm = this.id.split("_").pop();

			// query on permission url with "remove_perm" action
			$.post("/permissions", { permission_act: "rem_perm", perm_id: perm } );
		}
		
		return false;
	});
});

