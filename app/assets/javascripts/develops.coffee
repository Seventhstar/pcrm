# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@updateDev = ->
  param = {'search': $('#search').val(), 'show': $('.btn-group .btn.active').attr('show'), project_id: $('#dev_project :selected').val()}

  $.get 'develops/', param, null, 'script'
  setLoc("develops?"+ajx2q(param));
  return

@update_Develop = (dev_id)->
#  alert 'leadid'+lead_id
  $.get '/develops/'+dev_id+'/edit', "", null, "script"


# меняем отметки coder и boss непосредственно в index
$(document).ready ->
  
  params = width: '99.5%', disable_search: 'true'
  $('#develop_project_id').chosen(params)
  $('#develop_priority_id').chosen(params) 
  $('#develop_ic_user_id').chosen(params) 
  $('#develop_dev_status_id').chosen(params) 
  $('#dev_project').chosen(params).on 'change', ->
    updateDev()

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

  $('#develops_search .btn').click ->
    setTimeout 'updateDev()', 400
    return




  $('#develops_search').on 'click', '.btn-group input', ->
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