$(function() {
	
	$('#search_form').live('submit', function() {
		spin_the_wheel($('#search_form').attr('action') + '?' + $('.search_field').serialize());
		return false;
	});
	
	// Disabled due to selection of pages resetting search term which is not intendet
	// Also see: http://railscasts.com/episodes/175-ajax-history-and-bookmarks
	//           http://benalman.com/projects/jquery-bbq-plugin/
	/*
	$('#search_form select').live('change', function() {
		spin_the_wheel($('#search_form').attr('action') + '?' + $('#search_form select').serialize());
		return false;
	});
	*/
	
	$('.pagination a, .sorting a').live('click', function() {
		spin_the_wheel(this.href)
		return false;
	});
	
	function spin_the_wheel(url) {
		$('header').prepend('<div class="ajax_spinner"><img src="/images/spinner.gif"></div>');
		$.getScript(url);
	}
	
});
