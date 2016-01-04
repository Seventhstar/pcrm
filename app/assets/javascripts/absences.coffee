# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  chosen_params =
    width: '99.5%'
    disable_search: 'true'
  $('#absence_reason_id').chosen(chosen_params).on 'change', ->
    if $(this).val()=='2' 
      $('.p_obj').show()
    else
      $('.p_obj').hide()
