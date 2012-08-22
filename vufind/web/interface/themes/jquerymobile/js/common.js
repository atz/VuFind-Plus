// array holding translation strings for used in javascript code
// translated key/value pairs are generated by Smarty templates
_translations = Array();

// $.ajaxSetup({cache: false});

$(document).bind('mobileinit', function() {
	$.mobile.selectmenu.prototype.options.nativeMenu = false;
});

$('[data-role="page"]').live('pageshow', function() {
	var url = location.hash;
	if (url.length > 0) {
		url = url.substr(1);
	} else {
		url = location.href;
	}
	// update the language form action URL
	$('#langForm').attr('action', url);

	// update the "Go to Standard View" href
	var match = url.match(/([&?]?ui=[^&]+)/);
	if (match) {
		var replace = ((match[1].indexOf('?') != -1) ? '?' : '&') + 'ui=standard';
		url = url.replace(match[1], replace);
	} else {
		url += ((url.indexOf('?') == -1) ? '?' : '&') + 'ui=standard';
	}
	url = url.replace('&ui-state=dialog', '');
	$('a.standard-view').each(function() {
		$(this).attr('href', url);
	});
});

function pwdToText(fieldId){
	var elem = document.getElementById(fieldId);
	var input = document.createElement('input');
	input.id = elem.id;
	input.name = elem.name;
	input.value = elem.value;
	input.size = elem.size;
	input.onfocus = elem.onfocus;
	input.onblur = elem.onblur;
	input.className = elem.className;
	if (elem.type == 'text' ){
		input.type = 'password';
	} else {
		input.type = 'text'; 
	}

	elem.parentNode.replaceChild(input, elem);
	return input;
}

function moreFacets(name){
	$("#more" + name).hide();
	$(".narrowGroupHidden_" + name).show();
}
function lessFacets(name){
	$("#more" + name).show();
	$(".narrowGroupHidden_" + name).hide();
}

var ajaxCallback = null;
function ajaxLogin(callback){
	ajaxCallback = callback;
	ajaxLightbox(path + '/MyResearch/AJAX?method=LoginForm');
}

function ajaxLightbox(urlToLoad, parentId, left, width, top, height){
	
	var loadMsg = $('#lightboxLoading').html();
	$('#popupbox').html(loadMsg);
	$("#popupbox").dialog("open")
		
	$.get(urlToLoad, function(data) {
		$('#popupbox').html(data);
		
		if ($("#popupboxHeader").length > 0){
			$("#popupbox").draggable({ handle: "#popupboxHeader" });
		}
	});
}