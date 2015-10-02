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
	$('#receipt_project_id').chosen(chosen_params).on 'change', ->
		prj_id = $(this).val()
		if prj_id
			 $.getJSON '/projects/'+prj_id+'.json', (data) ->
				 $('#prj_sum').val(data.total)
			return
	$('.sum_mask').mask("# ##0", {reverse: true, maxlength: false})

	$('#receipt_payment_type_id').chosen(chosen_params)
	
	chosen_params = {width: '170px', allow_single_deselect: true}
	$('#receipts_provider').chosen(chosen_params).on 'change', ->
    receipt_query()
  $('#receipts_project_id').chosen(chosen_params).on 'change', ->
    receipt_query()
  $('#receipts_payment_type').chosen(chosen_params).on 'change', ->
    receipt_query()
  $('.container').on 'keyup', '#rcpt_search', ->    
    receipt_query()
  $('.calc_proc').on 'click', ->
  	$('#receipt_sum').val( to_sum($('#prj_sum').val() / $(this).attr('delim')) )