$(function() {
	
	$('.pagination a, .sorting a').live('click', function() {
		$('header').prepend('<div class="ajax_spinner"><img src="/images/spinner.gif"></div>');	
		$.get(this.href, null, null, 'script');
		return false;
	});
	
	$('#search_form').submit(function() {
		$('header').prepend('<div class="ajax_spinner"><img src="/images/spinner.gif"></div>');	
		$.get(this.href + this.serialize(), null, null, 'script');
		return false;
	});

	$('#search_form select').live('change', function() {
		$('header').prepend('<div class="ajax_spinner"><img src="/images/spinner.gif"></div>');
		url = $('#search_form').attr('action');
		params = '?' + $('#search_form select').serialize();
		$.get(url + params, null, null, 'script');
		return false;
	});

});