// Main UI Interaction

$(document).ready(function() {
	
	$(['/images/ajax-loader.gif']).preload();
	
	// In-place editing
	$('.best_in_place').best_in_place();

	//$('.posts_list').waitForImages(function() {
		//list_image_fitting();
	//})
	
	// Jquery UI Stuff
	$('input:submit').button();
	
	// Generc AJAX handling (jquery-ujs)
	var ujs_form = $("form[data-remote='true']");
	ujs_form.on('ajax:before', function(event) {
		console.log("ajax:before fired");
		$('.ajax_status', this).addClass('loading');
	});
	ujs_form.on('ajax:beforeSend', function(event, xhr, settings) {
		console.log("ajax:beforeSend fired");
	});
	ujs_form.on('ajax:success', function(event, data, status, xhr) {
		console.log("ajax:success fired");
		$('.ajax_status', this).removeClass('loading');
	});
	ujs_form.on('ajax:error', function(event, xhr, status, error) {
		console.log("ajax:error fired");
	});
	ujs_form.on('ajax:complete', function(event, xhr, status) {
		console.log("ajax:complete fired");
		$('.ajax_status', this).removeClass('loading');
	});
	ujs_form.on('ajax:aborted:required', function(event, elements) {
		console.log("ajax:aborted:required fired");
	});
	ujs_form.on('ajax:aborted:file', function(event, elements) {
		console.log("ajax:aborted:file fired");
	});

	
});

/////////////////////////////////////////////////////////
// Post _list image fitting
/////////////////////////////////////////////////////////

function list_image_fitting() {

	// Get initial image dimensions
	var imgs = $('.posts_list .post img');
	var iw = imgs.first().outerWidth();
	var ih = imgs.first().outerHeight();
	var ip = 42; // right padding
	
	// On resize, scale images accordingly
	$(window).resize(function() {
		scale();
	})
	scale(); // also scale on load
	function scale() {
		var vw = $('.posts_list').width();
		var new_iw = (vw-(ip*3))/3;
		imgs.each(function(){
			$(this).width(new_iw);
		})
	}
	
}

/////////////////////////////////////////////////////////
// Preload Images
/////////////////////////////////////////////////////////

$.fn.preload = function() {
    this.each(function(){
        $('<img/>')[0].src = this;
    });
}
