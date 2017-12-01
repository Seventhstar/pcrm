# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@receipt_procent_visibility = (prov_id) ->
	if (prov_id=='-1') then $('.calc_div').removeClass 'invisible' else $('.calc_div').addClass 'invisible' 

$(document).ready ->
  chosen_params =
    width: '99.5%'
    disable_search: 'true'
  $('#receipt_user_id').chosen chosen_params
  $('#receipt_payment_type_id').chosen chosen_params
  $('#receipt_provider_id').chosen(chosen_params).on 'change', ->
  	receipt_procent_visibility $('#receipt_provider_id').val()
  	return

  $('#receipt_project_id').chosen(chosen_params).on 'change', ->
    prj_id = $(this).val()
    if prj_id && (prj_id >0 || prj_id == -1)
     dt = $('#receipt_date').val()
     $.getJSON('/projects/' + prj_id + '.json',{'data': dt}, (data) ->
        $('#prj_sum').val data.total
        $('#cl_debt').attr 'cl_debt', to_sum(data.cl_debt)
        delim = data.total / data.cl_debt
        $('.calc_proc').each ->
          _span = $(this)
          _span.removeClass 'enabled'
          if parseInt(_span.attr('delim')) >= delim || _span.attr('delim')=='-1'
           _span.addClass 'enabled'
           return
         return
      )
    else
    	$('#prj_sum').val 0
    return
   
  $('.float_mask').mask "# ##0.00", 
    reverse: true
    maxlength: false

  $('.container').on 'click','.calc_proc.enabled', ->
    delim = $(this).attr('delim')
    if delim == '-1'
      $('#receipt_sum').val $(this).attr('cl_debt')
    else
      $('#receipt_sum').val to_sum($('#prj_sum').val() / delim)
    return
  return