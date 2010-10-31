// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function() {
	
	// Links in new Tabs or Windows
	$('.bookmark h1 a').click(function() {
		window.open($(this).attr('href'), '_blank');
		return false;
	});

	
	// Nice Notices
	$('#notice').css('opacity', 1);
	$('#notice').fadeTo(1250, 0.85).fadeTo(500, 0.33).slideUp().fadeTo(0, 0);
	$('#notice').click(function() {
		$(this).remove();
	});
	$('#notice').hover(function() {
		$('#notice').css('display', 'block');
	});
	
	$('#bookmarks header').hover(function() {
		$('#notice').css('display', 'block');
	}); 	

	
	/*
	// Buggy
	// Easy large links - clicky
	$('.bookmark').click(function() {
		window.open($(this).children('.the_link').children('a').attr('href'));
	});
	// Easy large links - mouse hover indicator
	$('.bookmark').hover(function() {
		$(this).css('cursor', 'pointer');
	});
	*/
	// Easy large links - background hover effect
	$('.bookmark').hover(
		function() {
			$(this).addClass('bookmark_hover');
		},
		function() {
			$(this).removeClass('bookmark_hover');
		}
	);

	
})