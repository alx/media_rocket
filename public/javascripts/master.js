



// function to send the jQuery form object via AJAX
jQuery.fn.submitWithAjax = function() {
  this.submit(function() {
    // be sure to add the '.js' part so that it knows this is format:js
    $.post(this.action + '.js', $(this).serialize(), null, "script");
    return false;
  })
  return this;
};
 
$(document).ready(function() {
  // once the page has completely loaded,
  // make links with the class "remote" submit via AJAX
  $("a.remote").click(function() {
	if(this.rel) $(this.rel).load(this.href);
	else $.get(this.href);
	return false;
  })
});

