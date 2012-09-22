// Main UI Interaction

var draww = {
    grid: {
        show: function (url, tile) {
            // Get current post ID
            var id = tile.attr('id');
            console.log(id);
            if($('#'+id+'_show').length > 0) {
                $('#index .show').hide();
                $('#'+id+'_show').show();
            } else {
                var overlay = $('.overlay', tile);
                overlay.addClass('loading');
    
                $.ajax({ url: url }).done(function(data){
                    overlay.removeClass('loading');
                    $('#index .show').hide();
                    
                    // Build a container and put the content in it
                    var container = $('<div class="show" id="'+id+'_show" />');
                    var push = tile.position().left > ($('#index').width())/2 ? "push-right" : "push-left";                
                    container.addClass(push);
                    container.addClass(tile.attr('class'));
                    container.removeClass('thumb');
                    container.html(data);
    
                    // Find the first tile on the current row and insert before it
                    var inserted = false;
                    $('.thumb').each(function(i){
                        if(!inserted) {
                            if($(this).position().top == tile.position().top) {
                                $(this).before(container);
                                inserted = true;
                            }
                        }
                    });
                    
                })
            }
        }
    }
}
$(document).ready(function() {
	
	$(['/images/ajax-loader.gif']).preload();
	
	// In-place editing
	$('.best_in_place').best_in_place();
	
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

	// Make comments submit on Enter key press
	
	$("#comment_body").keypress(function(event) {
		if ( event.which == 13 ) {
			$(this).submit();
		}
	});
        
    $("a.inspect").live("click", function() {
        draww.grid.show(this.href, $(this).parent().parent().parent());
        return false;
    });
	
});

/////////////////////////////////////////////////////////
// Preload Images
/////////////////////////////////////////////////////////

$.fn.preload = function() {
    this.each(function(){
        $('<img/>')[0].src = this;
    });
}
