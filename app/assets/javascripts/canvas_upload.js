/**
 * Canvas Upload Handler
 * 
 * Thanks to Jo Portus for some of this
 * What happens here then? Well...
 * 
 *  - We listen for 'drop' event when a file is dropped onto the browser
 *  
 *  - That file is read as a data url and sent off to the pjs instance for rendering
 *  
 *  - We put the hidden /posts/_form.html.erb into a BootStrap modal popup
 *  
 *  - An event is attached to the form's submit action (using jquery.form lib) that
 *    converts whatever's showing in the canvas to a Data URL and injects it into
 *    a hidden field in the form called post_attachment64 just before the form
 *    data gets POSTed.
 *
 * What it should be doing to sort resolution problems:
 *
 *  - Page starts with div showing drop area and hidden PJS
 *  - When image is dropped, div changes to spinner
 *  - PJS is resized to #container width
 *  - Image data is loaded into canvas
 *  - When that's finished, div is destroyed and canvas shown
 *  - User can resize image now with PJS controls
 *  - When save is clicked, canvas is hidden again and form is form partial is shown
 *  - Hidden canvas is resized to 1024x682 and image rendered using last crop&scale data
 *  - submit action does the dataurl injection as before.
 *  
 *  
 * PJS instance is scaled to width of #container
 * TODO: Get rid of all the shit for editing out of the upload js. It should be separate.
 *    
 */

// Set in pjs when something has been rendered in the canvas
var ready_to_save = false;
// Show controls in canvas pjs
var show_controls = true;
var pjs_instance;

$(document).ready(function() {

    // Preload spinner
    $(['/images/ajax-loader-big.gif']).preload();
    
    // Get interface elements
    var canvas = 	document.getElementById("canvas");
    var drop_area = 	document.getElementById("drop_area");
    var form_el = 	$('form.new_post, form.edit_post');
    var select_tool = 	$('#select_tool');

    // Init event handlers for drag and drop image loading
    drop_area.addEventListener("dragenter", dragEnter, false);
    drop_area.addEventListener("dragexit", dragExit, false);
    drop_area.addEventListener("dragover", dragOver, false);
    drop_area.addEventListener("drop", drop, false);

    form_el.submit(function() {
	// Inject image data into form
	$('#post_attachment64').val(canvas.toDataURL("image/jpeg"));
	
	// Populate title if blank
	var title_el = $('input#post_title');
	if(title_el.val().length < 1) {
		title_el.val(title_el.attr('placeholder'));
	}
    });

    // Resize Canvas
    pjsReadyFn['auto_resize'] = function() {
	pjs_instance = Processing.getInstanceById('canvas');
	resize_width();
	$(window).resize(function() { resize_width(); })
	
	// This resizes based on width AND height of viewport
	function r() {
	    // work out max size @ 3 to 2 aspect ratio
	    cw = $('#canvas_container').width();
	    ch = $(window).height() - $('nav.user').height() - 40;
	    w = cw;
	    h = (cw/3)*2
	    if(h > ch) {
		    h = ch;
		    w = (ch/2)*3; 
	    }
	    resizeCanvas(w,h);
	}
	
	// This resizes based on #canvas_container width only
	function resize_width() {
	    cw = $('#canvas_container').width();
	    console.log("Resizing to: "+cw);
	    ch = Math.round( (cw/3)*2 );
	    resizeCanvas(cw,ch);
	}
    }
    
    // Show drawing controls when mouse over canvas
    $('#canvas').mouseenter(function() {
	show_controls = true;
    }).mouseleave(function() {
	show_controls = false;
    });
    
    // Disable Carat pointer when drawing
    canvas.onselectstart = function () { return false; } // ie
    canvas.onmousedown = function () { return false; } // mozilla
    
    // Select Tool
    select_tool.change(function(){
	console.log($(this).val());
	pjs_instance.setTool($(this).val());
    });
    
    // Undo
    $('#undo').click(function() {
	pjs_instance.undo();
    })
});

function dragEnter(evt) {
    evt.stopPropagation();
    evt.preventDefault();
}

function dragExit(evt) {
    evt.stopPropagation();
    evt.preventDefault();
}

function dragOver(evt) {
    evt.stopPropagation();
    evt.preventDefault();
}

function drop(evt) {
    evt.stopPropagation();
    evt.preventDefault();

    var files = evt.dataTransfer.files;
    var count = files.length;

    // Only call the handler if 1 or more files was dropped.
    if (count > 0) {
	$('#drop_area').addClass('loading');
	handleFiles(files);
    }
}

var reader;

function handleFiles(files) {
    var file = files[0];

    reader = new FileReader();

    // init the reader event handlers
    //reader.onprogress = handleReaderProgress;

    // begin the read operation
    reader.readAsDataURL(file);

    // When it's read, send it off to a function that sends it to canvas
    reader.onloadend = handleReaderLoadEnd;

}
/*
function handleReaderProgress(evt) {
	if (evt.lengthComputable) {
		var loaded = (evt.loaded / evt.total);

		$("#progressbar").progressbar({ value: loaded * 100 });
	}
}
*/

//////////////////////////////////////////
// Linking functions to processing stuff
//////////////////////////////////////////

// On Ready handler:
// Add functions to this object to be called when Processing is ready
var pjsReadyFn = {}
function processingReady() {
    for(f in pjsReadyFn) {
	    pjsReadyFn[f]();
    }
}

// function imageLoaded(evt)
// {    
//      var p=Processing.getInstanceById('canvas');
// 	p.setImage( reader.result );
// }

function handleReaderLoadEnd(evt) {
    console.log('handleReaderLoadEnd called');
    pjs_instance.setImage( evt.target.result );
}

// This is called by embedded JS to load approriate image on edit pages
function loadRemoteImage(img) {
    pjs_instance.setImage(img);
}

function resizeCanvas(w, h) {
    console.log("resize js");
    pjs_instance.resizeCanvas(w, h);
}

function setToolFormEl(t) {
    console.log('JS setToolFormEl called');
    //$('#select_tool').selectmenu('index',t);
}

// Called when image is actually rendered in the PJS canvas
function imageRendered() {
    console.log('JS imageLoaded Called');
    $('#drop_area').hide();
    $('#canvas').show();
}