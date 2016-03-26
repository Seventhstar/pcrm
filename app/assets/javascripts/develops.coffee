# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# меняем отметки coder и boss непосредственно в index
$(document).ready ->
  
  params = width: '99.5%', disable_search: 'true'
  $('#develop_project_id').chosen(params)
  $('#develop_priority_id').chosen(params) 
  $('#develop_ic_user_id').chosen(params) 
  $('#develop_dev_status_id').chosen(params) 
  params = width: '200px', disable_search: 'true'
  $('#develops_project_id').chosen(params)

  $('.develops').on 'click', 'span.sw_check', ->
    checked = if $(this).hasClass('checked') then false else true
    dev_id = $(this).attr('developid')
    chk = $(this).attr('chk')
    th = $(this)
    
    $.ajax
      url: '/ajax/dev_check'
      data:
        'develop_id': dev_id
        'field': chk
        'checked': checked
      type: 'POST'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
        return
      success: ->
        if checked
          th.addClass 'checked'
        else
          th.removeClass 'checked'
        return
    return
  $('.container').on 'click','.btn-group .btn',-> 
    $('.btn-group label.active').removeClass 'active'
    $(this).addClass 'active'
    return
  return
