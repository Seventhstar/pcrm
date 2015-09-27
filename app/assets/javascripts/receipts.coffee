# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@receipt_query = ->
  p_params = $("#rcpt_search").serialize()
  $.get '/receipts', p_params, null, 'script'
  setLoc("receipts?"+p_params)

$(document).ready ->
	
	chosen_params = {width: '99.5%', disable_search: 'true'}
	$('#receipt_user_id').chosen(chosen_params)
	$('#receipt_provider_id').chosen(chosen_params)
	$('#receipt_project_id').chosen(chosen_params)
	$('#receipt_payment_type_id').chosen(chosen_params)
	
	chosen_params = {width: '170px', allow_single_deselect: true}
	$('#receipt_provider').chosen(chosen_params).on 'change', ->
    receipt_query()
  $('#receipt_payment_type').chosen(chosen_params).on 'change', ->
    receipt_query()
  $('.container').on 'keyup', '#rcpt_search', ->    
    receipt_query()