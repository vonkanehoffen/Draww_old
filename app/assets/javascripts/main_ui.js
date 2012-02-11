// Main UI Interaction

$(document).ready(function() {
	
	// In-place editing
	$('.best_in_place').best_in_place();

	//$('.posts_list').waitForImages(function() {
		//list_image_fitting();
	//})
	
	$('input:submit').button();
});

// Post _list image fitting
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

