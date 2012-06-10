/* Canvas Upload Handler with Jo! */

// Set in pjs when something has been rendered in the canvas
var ready_to_save = false;
// Show controls in canvas pjs
var show_controls = true;
var pjs_instance;

$(document).ready(function() {

	var canvas = document.getElementById("canvas");
	var form_el = $('form.new_post, form.edit_post');
	var select_tool = $('#select_tool');

	// init event handlers for drag and drop image loading
	canvas.addEventListener("dragenter", dragEnter, false);
	canvas.addEventListener("dragexit", dragExit, false);
	canvas.addEventListener("dragover", dragOver, false);
	canvas.addEventListener("drop", drop, false);

    form_el.submit(function() {
		// Inject image data into form
		if (ready_to_save) {
      		$('#post_attachment64').val(canvas.toDataURL("image/jpeg"));
		} else {
      		$('#post_attachment64').remove();
		}
		
		// Populate title if blank
		var title_el = $('input#post_title');
		if(title_el.val().length < 1) {
			title_el.val(title_el.attr('placeholder'));
		}
    });

	// Put form fields into a modal box
	form_el.dialog({
		title: 		"Save", 
		modal: 		true,
		width: 		500,
		autoOpen: 	false
	});
	$('#save_post').click(function(){
		form_el.dialog('open');
	});

	// Resize Canvas
	pjsReadyFn['auto_resize'] = function() {
		pjs_instance = Processing.getInstanceById('canvas');
		r();
		$(window).resize(function() { r(); })
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
	if (count > 0)
		handleFiles(files);
}

var objImage;
var reader;

function handleFiles(files) {
	var file = files[0];

	reader = new FileReader();

	// init the reader event handlers
	//reader.onprogress = handleReaderProgress;
	reader.onloadend = handleReaderLoadEnd;

	// begin the read operation
	reader.readAsDataURL(file);
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
	//console.log("target="+evt.target.result);
	//var cache_sketch = Processing.Sketch;
	//cache_sketch.imageCache.images = evt.target.result;
	//cache_sketch.onFrameStart = function() {
	//	console.log('onFrameStart called');
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
	console.log('st called');
	$('#select_tool').selectmenu('index',t);
}