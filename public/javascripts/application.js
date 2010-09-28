// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function() {
    $('a[rel=external]').attr('target', 'blank');

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
	            //     $('.pagination a').append('<h4>' + $(this).find('title').text() + '</h4><p>' + $(this).find('link').text() + '</p>');
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