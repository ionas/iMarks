// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function() {
	$('.bookmark h1 a').attr('target', 'blank');

	function saveBookmark(evt){
		$('#bookmark_submit').click()
		return false;
	}
	
	$(document).bind('keydown', 'ctrl+s', saveBookmark);
	$(document).bind('keydown', 'alt+s', saveBookmark);
	$(document).bind('keydown', 'meta+s', saveBookmark);
	
	/*
	$("[title]").tooltip({
		// place tooltip on the right edge
		position: "bottom right",
		// a little tweaking of the position
		offset: [-10, -50],
		// use the built-in fadeIn/fadeOut effect
		effect: "fade",
		// custom opacity setting
		opacity: 0.7
	});	
	*/	

	/*
	$('.pagination a').click(function() {
		$.ajax({
	
			type: 'get',
			url: $(this).attr("href"),

			beforeSend: function() {
				// this is where we append a loading image
 				alert('loading');
				// $(this).append('<img src="/images/spinner.gif" alt="Loading..." />');
			},

			success: function(data) {
				// successful request; do something with the data
				alert(data);
				$('.pagination #bookmarks').empty();
	
				// $(data).find('item').each(function(i) {
				//	 $('.pagination a').append('<h4>' + $(this).find('title').text() + '</h4><p>' + $(this).find('link').text() + '</p>');
				// });
	
			},

			error: function() {
				// failed request; give feedback to user
				$('.pagination a').html('<p class="error"><strong>Oops!</strong> Try that again in a few moments.</p>');
			}
		});
		return false; // later, if error: return true, else return false
	});
*/
})