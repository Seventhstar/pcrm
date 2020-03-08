# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# меняем отметки coder и boss непосредственно в index
$(document).ready ->
  
  $('.develops').on 'click', 'span.dev_check', ->
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
