# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  chosen_params = undefined
  chosen_params =
    width: '99.5%'
    disable_search: 'true'
  $('#shop_shop_id').chosen chosen_params
  $('#absence_reason_id').chosen(chosen_params).on 'change', ->
    if $(this).val() == '2'
      $('.p_obj').show()
    else
      $('.p_obj').hide()
    if $(this).val() == '3'
      $('#dshops').show()
    else
      $('#dshops').hide()
  $('#dt_to_check').on 'click', ->
    $(this).toggleClass 'checked'
    $('#absence_checked').val $(this).hasClass('checked')
    if $(this).hasClass('checked')
      $('#absence_dt_to').addClass 'datepicker'
      $('#absence_dt_to').prop 'disabled', false
    else
      $('#absence_dt_to').removeClass 'datepicker'
      $('#absence_dt_to').attr 'disabled', 'disabled'
    return
  return
