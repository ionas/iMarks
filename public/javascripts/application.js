// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function() {
	
	// Links in new Tabs or Windows
	$('.bookmark h1 a').attr('target', 'blank');

	// jquery.hotkey: CTRL+S
	function saveBookmark(evt){
		$('#bookmark_submit').click()
		return false;
	}
	$(document).bind('keydown', 'ctrl+s', saveBookmark);
	$(document).bind('keydown', 'alt+s', saveBookmark);
	$(document).bind('keydown', 'meta+s', saveBookmark);
	
})