# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

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

