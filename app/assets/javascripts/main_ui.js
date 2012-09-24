/**
 * Draww
 * Main UI Interaction
 */

var draww = {
    
    pjs: {}, // Global to reference Processing canvas. Populated from framework.pjs
    show_controls: {},

    view: {
        
        // Fetch posts/show view with ajax and insert into image grid
        
        show_post: function (url, tile) {
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
                    $('#index .new_post').remove();
                    
                    // Build a container and put the content in it
                    var container = $('<div class="show" id="'+id+'_show" />');
                    var push = tile.position().left >= ($('#index').width())/2 ? "push-right" : "push-left";                
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
        },
        
        // Fetch posts/new view with Ajax and attach upload handlers
        
        new_post: function(url) {
            var container = $('<div class="new_post loading" />');
            $('#index .show').hide();
            $('#index').prepend(container);
            $.ajax({ url: url }).done(function(data){
                container.removeClass("loading");
                container.html(data);
                draww.editor.init_pjs('pjs_canvas');
                draww.editor.attach_dnd_handlers($('#drop_area'));
            });
        }
    },
    editor: {
        
        // Create and attach handlers for image drag & drop.
        // The handlers read the image into the canvas and start the editor
        
        attach_dnd_handlers: function(el) {
            
            function ignore(evt) {
                evt.stopPropagation();
                evt.preventDefault();
            }

            el.bind("dragenter dragover", function(evt) {
                ignore(evt);
                el.addClass('over');
            });

            el.bind("dragleave dragexit", function(evt) {
                ignore(evt);
                el.removeClass('over');
            });

            el.bind("drop", function(evt) {
                ignore(evt);
                el.removeClass('over').addClass('loading');
                var dt = evt.originalEvent.dataTransfer;
                var files = dt.files;

                if(dt.files.length > 0){
                    var file = dt.files[0];
                    var reader = new FileReader();
                    // init the reader event handlers
                    //reader.onprogress = handleReaderProgress;

                    reader.readAsDataURL(file);
                    reader.onloadend = function(evt){
                        draww.pjs.setImage( evt.target.result );
                    }
                }
            });
        },
        init_pjs: function(canvas_id) {
            Processing.loadSketchFromSources(canvas_id,
                ['/assets/framework.pjs', '/assets/tools.pjs']); //, '/assets/tools.pjs'
        },
        
        // Callbacks triggered from processing.js 
        callback: {
            pjs_loaded: function() {
                draww.pjs = Processing.getInstanceById('pjs_canvas');
            },
            image_rendered: function() {
                $('#drop_area').hide();
                $('#pjs_canvas').show();
            }
        },
        
        prepare_upload: function(form) {
            $("input[type='submit']", form).val('Uploading').attr("disabled", true);
            // Inject image data into form
            console.log("injecting to", $('#post_attachment64', form));
            $('#post_attachment64', form).val(
                document.getElementById("pjs_canvas").toDataURL("image/jpeg")
            );
            // Populate title if blank
            var title_el = $('input#post_title', form);
            if(title_el.val().length < 1) {
                    title_el.val(title_el.attr('placeholder'));
            }
        }
    }
}

// Setup handlers when everything's loaded

$(document).ready(function() {
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
        if (event.which == 13) $(this).submit();
    });
    
    // posts/show
    $("a.inspect").live("click", function() {
        draww.view.show_post(this.href, $(this).parent().parent().parent());
        return false;
    });
    
    // posts/new
    $("#navbar .new a").click(function() {
        draww.view.new_post(this.href);
        return false;
    });
    $("form#new_post").live("submit", function() {
        draww.editor.prepare_upload($('form#new_post'));
    });
    
});
