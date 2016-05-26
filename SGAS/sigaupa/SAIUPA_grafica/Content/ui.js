//two variables: Controller and Action have to be initialized in the View HTML code
$(document).ready(function() {
	setEvents();
	disableButton ($("#edit_button"),0);
	disableButton ($("#details_button"),0);
	disableButton ($("#delete_button"),0);
});

function setEvents() {
    $('.ui_selector').each(function() {
        $(this).bind('click', function() {
            onSelectorClick(this);
        });
    });
}

function onSelectorClick(_selector){
	var _r = $(_selector).closest('tr');
	if ($(_r).hasClass('ui_selected')) {
	    $(_r).removeClass('ui_selected').addClass('ui_notselected');
	    disableButton ($("#edit_button"),100);
	    disableButton ($("#details_button"),100);
	    disableButton ($("#delete_button"),100);
	}
	else{
		var _tb = $(_r).closest('table');
		$("tr", _tb).removeClass('ui_selected').addClass('ui_notselected');
		$(_r).removeClass('ui_notselected').addClass('ui_selected');
        
        var rID = $(_selector).attr('rowid')
	    enableButton ($("#edit_button"), Controller, "Edit", rID);
	    enableButton ($("#details_button"), Controller, "Details", rID);
	    enableButton ($("#delete_button"), Controller, "Delete", rID);
	}
	
}

function enableButton(_button, _controller, _action, id){
    //$(_button).prop("disabled", false);
    $(_button).fadeIn(100);
	$(_button).bind('click', function(){
		window.location.href='?controller=' + _controller + '&action=' + _action + '&id=' + id;
		//you may re-define the appearance of the form as pop-up or dialog(using JQuery)
    });
}

function disableButton(_button, fadeOutLen){
    $(_button).fadeOut(fadeOutLen);
	$(_button).bind('click', function(){});
}