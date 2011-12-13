/* Canvas Upload Handler with Jo! */

$(document).ready(function() {
	if($('#canvas').length) {
		// TODO: This script should be conditionally included only on new & edit pages
		var dropbox = document.getElementById("canvas")

		// init event handlers
		dropbox.addEventListener("dragenter", dragEnter, false);
		dropbox.addEventListener("dragexit", dragExit, false);
		dropbox.addEventListener("dragover", dragOver, false);
		dropbox.addEventListener("drop", drop, false);
	
		// Save canvas
	    $('#new_post, form.edit_post').submit(function() {
	      $('#post_attachment64').val(dropbox.toDataURL("image/jpeg"));
	    });
	}
	
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
function imageLoaded(evt)
{    
     var p=Processing.getInstanceById('canvas');
	p.setImage( reader.result );
}

function handleReaderLoadEnd(evt) {
	var p=Processing.getInstanceById('canvas');
    ////p.resize($("#main").width(),$("#main").height());
	p.setImage( evt.target.result );
}

// This is called by embedded JS to load approriate image on edit pages
function loadRemoteImage(img) {
	var p=Processing.getInstanceById('canvas');
	console.log(p);
	p.setImage(img);
}
