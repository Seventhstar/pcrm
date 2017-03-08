# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
	$('.comments_box').on 'click', '.item', ->
		comm_id = $(this).attr('commentid')  
		$(this).removeClass('new')  
		$.ajax
			url: '/ajax/read_comment'
			data:
			  'comment_id': comm_id
			type: 'POST'
		return