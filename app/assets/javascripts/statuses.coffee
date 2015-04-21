# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready ->
  $('.tstatuses').on 'click', 'span.check_img', ->
    #alert(228)
    if $(this).hasClass('checked')
      $(this).removeClass 'checked'
      checked = false
    else
      checked = true
      $(this).addClass 'checked'
    status_id = $(this).attr('statusid')
    chk = $(this).attr('chk')
    
    $.ajax
      url: '/ajax/status_check'
      data:
        'status_id': status_id
        'field': chk
        'checked': checked
      type: 'POST'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
        return
      success: ->
        $(this).addClass 'done'
        return
    #alert($('.active').attr('show'));    
    return
