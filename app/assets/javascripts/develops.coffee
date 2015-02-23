# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@updateDev = ->
  $.get 'develops/', {
    'search': $('#search').val()
    'show': $('.active').attr('show')
  }, null, 'script'
  return

# меняем отметки coder и boss непосредственно в index
$(document).ready ->
  $('#develops_list').on 'click', 'span.check_img', ->
    #alert(228);
    if $(this).hasClass('checked')
      $(this).removeClass 'checked'
      checked = false
    else
      checked = true
      $(this).addClass 'checked'
    dev_id = $(this).attr('developid')
    chk = $(this).attr('chk')
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
        $(this).addClass 'done'
        return
    return

  $('#develops_search .btn').click ->
    setTimeout 'updateDev()', 400
    return

  $('#develops_search input').keyup ->
    c = String.fromCharCode(event.keyCode)
    isWordcharacter = c.match(/\w/)
    if isWordcharacter or event.keyCode == 8
      s = 1
      setTimeout 'updateDev()', 400
    false