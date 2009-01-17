/**
 * Ajax upload plugin for jQuery
 * Project page - http://valums.com/ajax-upload/
 * Copyright (c) 2008 Andris Valums, http://valums.com
 * Licensed under the MIT license (http://valums.com/mit-license/)
 */
(function($){
	// we need jQuery to run
	if ( ! $) return;

	/**
	 * Function generates unique id
	 */		
	var get_uid = function(){
		var uid = 0;
		return function(){
			return uid++;
		}
	}();

	/**
	 * button - jQuery element
	 * option - hash of options :
	 *   action - URL which iframe will use to post data
	 *   name - file input name
	 *   data - extra data hash to post within the file
	 *   onSubmit - callback to fire on file submit
	 *   onComplete - callback to fire when iframe has finished loading
	 */
	window.Ajax_upload = function(button, options){
		// make sure it is jquery object
		button = $(button);
		
		if (button.size() != 1 ){
			console.error('You passed ', button.size(),' elements to ajax_upload at once');
			return false;
		}
				
		this.button = button;
				
		this.wrapper = null;
		this.form = null;
		this.input = null;
		this.iframe = null;		

		this.disabled = false;
		this.submitting = false;
				
		this.settings = {
			// Location of the server-side upload script
			action: 'upload.php',			
			// File upload name
			name: 'userfile',
			// Additional data to send
			data: {},
			// Callback to fire when user selects file
			// You can return false to cancel upload
			onSubmit: function(file, extension) {},
			// Fired when file upload is completed
			onComplete: function(file, response) {}
		};

		// Merge the users options with our defaults	
		$.extend(this.settings, options);
		
		this.create_wrapper();
		this.create_input();
		
		if (jQuery.browser.msie){
			// fix ie transparent background bug
			this.make_parent_opaque();
		}
		
		this.create_iframe();		
	}
	
	// assigning methods to our class
	Ajax_upload.prototype = {
		set_data : function(data){
			this.settings.data = data;
		},
		disable : function(){
			this.disabled = true;
			if ( ! this.submitting){
				this.input.attr('disabled', true);
				this.button.removeClass('hover');	
			}			
		},
		enable : function(){
			this.disabled = false;
			this.input.attr('disabled', false);							
		},
		/**
		 * Creates wrapper for button and invisible file input
		 */
		create_wrapper : function(){
			// Shorten names			
			var button = this.button, wrapper;
			
			wrapper = this.wrapper = $('<div></div>')
				.insertAfter(button)
				.append(button);			

			// wait a bit because of FF bug
			// it can't properly calculate the outerHeight
			setTimeout(function(){
				wrapper.css({
					position: 'relative'
					,display: 'block'
					,overflow: 'hidden'

					// we need dimensions because of ie bug that allows to move 
					// input outside even if overflow set to hidden					
					,height: button.outerHeight(true)
					,width: button.outerWidth(true)
				});						
			}, 1);
			
			var self = this;
			wrapper.mousemove(function(e){
				// Move the input with the mouse, so the user can't misclick it
				if (!self.input) {
					return;
				}
									
				self.input.css({
					top: e.pageY - wrapper.offset().top - 5 + 'px'
					,left: e.pageX - wrapper.offset().left - 170 + 'px'
				});
			});

	
		},
		/**
		 * Creates invisible file input above the button 
		 */
		create_input : function(){
			var self = this;

			this.input = 
				$('<input type="file" />')
				.attr('name', this.settings.name)				
				.css({
					'position' : 'absolute'
					,'margin': 0
					,'padding': 0
					,'width': '220px'
					,'height': '10px'										
					,'opacity': 0								
				})
				.change(function(){
					if ($(this).val() == ''){
						// there is no file
						return;
					}
					
					// we need to lock "disable" method
					self.submitting = true;
					
					// Submit form when value is changed
					self.submit();
					
					if (self.disabled){
						self.disable();					
					}						
					// unlock "disable" method
					self.submitting = false;					
				})
				.appendTo(this.wrapper)
				
				// Emulate button hover effect				
				.hover(
					function(){self.button.addClass('hover');}
					,function(){self.button.removeClass('hover');}
				);
				
			if (this.disabled){
				this.input.attr('disabled', true);
			}

		},
		/**
		 * Creates iframe with unique name
		 */
		create_iframe : function(){
			// unique name
			// We cannot use getTime, because it sometimes return
			// same value in safari :(
			var id = 'valums97hhu' + get_uid();
			
			// create iframe, so we dont need to refresh page
			this.iframe = 
				$('<iframe id="' + id + '" name="' + id + '"></iframe>')
				.css('display', 'none')
				.appendTo('body');									
		},
		/**
		 * Upload file without refreshing the page
		 */
		submit : function(){			
			var self = this, settings = this.settings;			
			
			// get filename from input
			var file = this.file_from_path(this.input.val());			

			// execute user event
			if (settings.onSubmit.call(this, file, this.get_ext(file)) === false){
				// Do not continue if user function returns false						
				return;
			}			

			this.create_form();
			this.input.appendTo(this.form);			
			this.form.submit();			
			
			this.input.remove(); this.input = null;
			this.form.remove();	this.form = null;

			this.submitting = false;
			
			// create new input
			this.create_input();	
	
			var iframe = this.iframe;
			iframe.load(function(){
				var response = iframe.contents().find('body').html();	
		
				settings.onComplete.call(self, file, response);				
				/// Workaround for FF2 bug, which causes cursor to be in busy state after post.
				setTimeout(function(){
					iframe.remove();
				}, 1);				
			});
			
			// Create new iframe, so we can have multiple uploads at once
			this.create_iframe();		
		},		
		/**
		 * Creates form, that will be submitted to iframe
		 */
		create_form : function(){
			// method, enctype must be specified here
			// because changing this attr on the fly is not allowed in IE 6/7
			this.form = 
				$('<form method="post" enctype="multipart/form-data"></form>')				
				.attr({
					"action" : this.settings.action
					,"target" : this.iframe.attr('name')					
				})
				.appendTo('body');			
			
			// Create hidden input element for each data key
			for (var i in this.settings.data){
				$('<input type="hidden" />')
					.appendTo(this.form)
					.attr({
						'name': i
						,'value': this.settings.data[i]
					});
			}
		},		
		file_from_path : function(file){
			return file.replace(/.*(\/|\\)/, "");			
		},
		get_ext : function(file){
			return (/[.]/.exec(file)) ? /[^.]+$/.exec(file.toLowerCase()) : '';
		},
		make_parent_opaque : function(){
			// ie transparent background bug
			this.button.add(this.button.parents()).each(function(){				
				var color = $(this).css('backgroundColor');
				var image = $(this).css('backgroundImage');
	
				if ( color != 'transparent' ||  image != 'none'){
					$(this).css('opacity', 1);
					return false;
				}
			});			
		}
		
	};
})(jQuery);