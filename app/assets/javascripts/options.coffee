# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

 $('.tleads').on 'click', 'span.check_img', ->
  is_status_table = $(this).parents('table').attr('model')
  #alert(is_status_table)
  if is_status_table == 'Status' 
    if $(this).hasClass('checked')
      $(this).removeClass 'checked'
      checked = false
    else
      checked = true
      $(this).addClass 'checked'
    status_id = $(this).attr('sid')
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
    return

# menu 
 $('#accordion').accordion
   header: 'h3'
   active: parseInt($('#accordion').attr('active'))
   collapsible: true
   heightStyle: 'content'
   autoHeight: false
   navigation: true

# перемещение по меню
 $('.menu_sb li a').click ->
   $('.menu_sb li.active').removeClass 'active', 1000
   $(this).parent().addClass 'active' , {duration:500}
   url = '/' + $(this).attr('controller')
   #alert url
   $.get url, null, null, 'script'
   if url != '/undefined'
     setLoc 'options' + url

# запись нового элемента простого справочника
$(document).on 'click', '#btn-send', (e) ->
  valuesToSubmit = $('form').serialize()
  values = $('form').serialize()
  url = $('form').attr('action')
  empty_name = false
  #alert values
  each q2ajx(values), (i, a) ->
    if i.indexOf('[name]') > 0 and a == ''
      empty_name = true
      return false
    return
  if !empty_name
    $.ajax
      type: 'POST'
      url: url
      data: valuesToSubmit
      dataType: 'JSON'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
        return
      success: ->
        $.get url, null, null, 'script'
        return
      error: (evt, xhr, status, error) ->
        #alert(status)
        errors = evt.responseText
        #alert(errors)
        show_ajax_message(errors,'error')
        showNotifications();
  false

# удаляем элемент справочника
$(document).on 'click', ' span.icon_remove', ->
    url = $('form').attr('action')
    item_id = $(this).attr('item_id')
    del_url = url + '/' + item_id
    del = confirm('Действительно удалить?')
    if !del
      return
    $.ajax
      url: del_url
      data: '_method': 'delete'
      dataType: 'json'
      type: 'POST'
      complete: ->
        $.get url, null, null, 'script'
        return
    return

