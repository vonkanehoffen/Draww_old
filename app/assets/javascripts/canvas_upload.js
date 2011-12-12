/* Canvas Upload Handler with Joe! */

$(document).ready(function() {
	var dropbox = document.getElementById("canvas")

	// init event handlers
	dropbox.addEventListener("dragenter", dragEnter, false);
	dropbox.addEventListener("dragexit", dragExit, false);
	dropbox.addEventListener("dragover", dragOver, false);
	dropbox.addEventListener("drop", drop, false);

	// init the widgets
	//$("#progressbar").progressbar();
	// $("#new_post").ajaxForm({
	// 		target: 		'#ajax_out',			// target element(s) to be updated with server response 
	// 		beforeSubmit: 	showRequest,  			// pre-submit callback 
	// 		success: 		showResponse  			// post-submit callback
	// 	});
	// $('#new_post input[name="commit"]').click(function() {
	// 		console.log($('#new_post input[name="post\\[title\\]"]').val());
	// 		return false;		
	// 	});
	// save_init();
	
    $('#new_post').submit(function() {
      $('#post_attachment64').val(dropbox.toDataURL());
    });
	
});

// pre-submit callback 
function showRequest(formData, jqForm, options) { 
    // formData is an array; here we use $.param to convert it to a string to display it 
    // but the form plugin does this for you automatically when it submits the data 
    var queryString = $.param(formData); 
 
    // jqForm is a jQuery object encapsulating the form element.  To access the 
    // DOM element for the form do this: 
    // var formElement = jqForm[0]; 
 
    console.log('About to submit: \n\n' + queryString); 
 
    // here we could return false to prevent the form from being submitted; 
    // returning anything other than false will allow the form submit to continue 
    return true; 
} 
 
// post-submit callback 
function showResponse(responseText, statusText, xhr, $form)  { 
    // for normal html responses, the first argument to the success callback 
    // is the XMLHttpRequest object's responseText property 
 
    // if the ajaxForm method was passed an Options Object with the dataType 
    // property set to 'xml' then the first argument to the success callback 
    // is the XMLHttpRequest object's responseXML property 
 
    // if the ajaxForm method was passed an Options Object with the dataType 
    // property set to 'json' then the first argument to the success callback 
    // is the json data object returned by the server 
 
    console.log('status: ' + statusText + '\n\nresponseText: \n' + responseText + 
        '\n\nThe output div should have already been updated with the responseText.'); 
}

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

/////////////////////////////////////////////////////////////////////
// UPLOAD IMAGE DATA FOR SAVING
/////////////////////////////////////////////////////////////////////

function save_init() {

	$('#new_post input[name="commit"]').click(function(event) {
		
		event.preventDefault();
		// Get canvas (worked without this line in Chrome but not Firefox for some reason?)
		canvas = document.getElementById("canvas");
		// get image data from cavas
		var img = canvas.toDataURL("image/jpeg");
		
		var ajax_out = $("#ajax_out");
		ajax_out.html('<img src="/images/loading.gif" alt="Loading..." />');
		
		// open ajax request
		var ajax = new XMLHttpRequest();
		ajax.open("POST",'http://127.0.0.1:10520/posts',false); 
		//ajax.open("POST","/dumpvars.php",false); // testing

		// set headers
		boundary_str = "AJAX-------------" + (new Date).getTime();
		ajax.setRequestHeader('Content-Type', "multipart/form-data; boundary=" + boundary_str);

		// callback for completed request
		ajax.onreadystatechange=function()
	    {
	        if (ajax.readyState == 4)
	        { 
	            // Write out the filename.
				ajax_out.html(ajax.responseText);
	        }
	    }

		// BUILD REQUEST
		var boundary = '--' + boundary_str; 
		var request_body = boundary + '\n'
		// print all html form fields
		$('#new_post input').each(function(){ 
			request_body += 'Content-Disposition: form-data; name="' 
			+ $(this).attr('name') + '"' + '\n' 
		    + '\n' 
		    + $(this).val() + '\n' 
		    + '\n' 
		    + boundary + '\n';
		});
		// make filename
		var filename = $('#new_post input[name="post\\[title\\]"]').val();
		filename = filename.replace(/\s+/g, '-').toLowerCase(); // hyphenate + lowercase
		filename = encodeURIComponent(filename) + (new Date).getTime() + ".jpg";
		// add image
		request_body += 'Content-Disposition: form-data; name="post[photo]"; filename="' 
	        + filename + '"' + '\n'
	    + 'Content-Type: image/jpeg' + '\n' 
	    + '\n' 
	    + img
	    + '\n' 
	    + boundary;

		// Send request
		ajax.send(request_body);
		
	});

};	
