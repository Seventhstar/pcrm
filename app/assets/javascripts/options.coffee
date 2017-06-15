$(document).ready ->
 $(document).on 'click', '.sw_enable', ->
  grp_id = $(this).attr('grp_id')
  ch = $(this).find('.checkbox').hasClass('active')
  $('.grp'+grp_id).prop('disabled',ch)
  $('.grp'+grp_id).children().each ->
    if ch then $(this).addClass('disabled') else $(this).removeClass('disabled')
 $('.page-wrapper').on 'click', 'span.sw_check',  ->
  model = $(this).parents('table').attr('model')
  if $(this).hasClass('checked')
    $(this).removeClass 'checked'
    checked = false
  else
    $(this).addClass 'checked'
    checked = true
    
  item_id = $(this).attr('item_id')
  chk = $(this).attr('chk')
  tr = $(this).closest('tr')
  
  table = $(this).closest('table')
  color_cls = table.attr('color_cls')
  if !chk
    chk = table.find('th:eq('+$(this).closest('td')[0].cellIndex+')').attr('fld')

  $.ajax
    url: '/ajax/switch_check'
    data:
      'model': model
      'item_id': item_id
      'field': chk
      'checked': checked
    type: 'POST'
    beforeSend: (xhr) ->
      xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
      return
    success: ->
      if tr.hasClass('sw_color') || color_cls!=undefined
        if tr.hasClass(color_cls) 
          tr.removeClass(color_cls)
        else
          tr.addClass(color_cls)
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
   url = $(this).attr('controller')
   if url.indexOf('options')<1
    url = 'options/' + url
   url= url.replace('#','')
   if url != '/undefined'
     $.ajax
       url: '/'+url
       dataType: 'script'
       success: ->
        setLoc url

$(document).on 'click', '#btn-sub-send', (e) ->
  attr_url = $(this).attr('action')
  prm = $(this).attr('prm')
  values = $('[name^='+prm+']').serialize()
  url = document.URL
  if url.indexOf('edit')<1 then url = url + '/edit'
  #alert url
  $.ajax
    type: 'POST'
    url: attr_url
    data: values
    dataType: 'JSON'
    beforeSend: (xhr) ->
      xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
      return
    success: ->
      $.get url, null, null, 'script'
      show_ajax_message 'Успешно добавлено'
      return
    error: (evt, xhr, status, error) ->      
      errors = evt.responseText
      #alert(typeof(errors))
      show_ajax_message(errors,'error')
      showNotifications();
  return

# запись нового элемента простого справочника
$(document).on 'click', '#get-holidays', (e) ->
  url = '/options'+$('form').attr('action')
  $.ajax
      type: 'POST'
      url: '/ajax/update_holidays'
      success: (xhr, data, response) ->
        $.get url, null, null, 'script'

# запись нового элемента простого справочника
$(document).on 'click', '#btn-send', (e) ->
  valuesToSubmit = $('form').serialize()
  values = $('form').serialize()
  url = '/options'+$('form').attr('action')
  #alert url
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
      success: (xhr, data, response) ->
        $.get url, null, null, 'script'
        show_ajax_message 'Успешно записано'
        return
      error: (evt, xhr, status, error) ->
        show_ajax_message(evt.responseText,'error')
    return
  return

# удаляем элемент справочника
$(document).on 'click', ' span.icon_remove', ->
    item_id = $(this).attr('item_id')
    url = document.URL.replace('#', '') #$('form').attr('action')
    attr_url = $(this).parents('table').attr('action') 
    if attr_url!=undefined
      del_url = '/'+attr_url + '/' + item_id
    else
      del_url = url + '/' + item_id
    if url.indexOf('edit')<1 && url.indexOf('options')<1 then url = url + '/edit'
   # url = url.replace('options/','')  
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
        show_ajax_message('Успешно удалено')
        return
    return