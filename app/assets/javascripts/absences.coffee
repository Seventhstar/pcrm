# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  chosen_params = undefined
  chosen_params =
    width: '99.5%'
    disable_search: 'true'
  $('#shop_shop_id').chosen({width: '99.5%'})
  $('#absence_reason_id:not(input[type=hidden])').chosen(chosen_params).on 'change', ->
    switch $(this).val()
      when '2'
        $('.p_obj').show()
        $('.p_trgt').show()
        $('#dshops').hide()
      when '3'
        $('.p_obj').show()
        $('.p_trgt').hide()
        $('#dshops').show()
        if $('#absence_reopen').attr('action_name')=='new'
          $('#absence_reopen').val( true)
          $('#new_absence').submit()
        return
      else
        $('.p_obj').hide()
        $('.p_trgt').hide()
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
  $('#div_tabsences').on 'click','.cal-next',->
    sortable_query({m: $(this).attr('cur-period')})
  return