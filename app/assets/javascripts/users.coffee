# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('.user-table').on 'click', 'span.check_img', ->
    if $(this).hasClass('checked')
      $(this).removeClass 'checked'
      checked = false
    else
      checked = true
      $(this).addClass 'checked'
    user_id = $(this).attr('userid')
    chk = $(this).attr('chk')
    $.ajax
      url: '/ajax/user_upd'
      data:
        'user_id': user_id
        'field': chk
        'checked': checked
      type: 'POST'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
        return
      success: ->
        $(this).addClass 'done'
        return
    return
