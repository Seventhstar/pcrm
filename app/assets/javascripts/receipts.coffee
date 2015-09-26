# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
	$('#receipt_user_id').chosen(width: '99.5%', disable_search: 'true')
	$('#receipt_provider_id').chosen(width: '99.5%', disable_search: 'true')
	$('#receipt_project_id').chosen(width: '99.5%', disable_search: 'true')
	$('#receipt_payment_type_id').chosen(width: '99.5%', disable_search: 'true')