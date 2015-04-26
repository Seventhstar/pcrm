# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@updateDev = ->
  param = {'search': $('#search').val(), 'show': $('.btn-group .btn.active').attr('show')}

  $.get 'develops/', param, null, 'script'
  setLoc("develops?"+ajx2q(param));
  return

# меняем отметки coder и boss непосредственно в index
$(document).ready ->
  $('#develop_project_id').chosen(width: '402px', disable_search: 'true')
  $('.develops').on 'click', 'span.check_img', ->
    #alert(228)
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
    #alert($('.active').attr('show'));    
    return

  $('#develops_search .btn').click ->
    setTimeout 'updateDev()', 400
    return

  $('#develops_search').on 'click', '.btn-group input', ->
    #alert(28)
    $('.btn-group label.active').removeClass 'active'
    $('.btn-group label.active .radio').removeClass 'active'
    $(this).parent().parent().addClass 'active'
    return

  $('#develops_search input').keyup ->
    c = String.fromCharCode(event.keyCode)
    isWordcharacter = c.match(/\w/)
    if isWordcharacter or event.keyCode == 8
      s = 1
      setTimeout 'updateDev()', 400
    false