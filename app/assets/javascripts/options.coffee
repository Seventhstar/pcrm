@switch_check_ajax = (data,tr,cls) ->
  $.ajax
    url: '/ajax/switch_check'
    data: data   
    type: 'POST'
    beforeSend: (xhr) ->
      xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
      return
    success: ->
      if tr.hasClass('sw_color') || cls!=undefined
        if tr.hasClass(cls) 
          tr.removeClass(cls)
        else
          tr.addClass(cls)

@switch_check = (el) ->
  if el.hasClass('checked')
    el.removeClass 'checked'
    checked = false
  else
    el.addClass 'checked'
    checked = true
  return checked

@save_item = (button) ->
  attr_url = button.attr('action')
  prm = button.attr('prm')
  values = $('[name^='+prm+']').serialize()+'&owner_id='+$('form').attr('id')
  url = document.URL
  if url.indexOf('edit')<1 then url = url + '/edit'
  $.ajax
    type: 'POST'
    url: attr_url
    data: values
    dataType: 'script'
    beforeSend: (xhr) ->
      xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
      return
    success: (data, textStatus, jqXHR ) ->
      if data.includes('.js-notes')
        show_ajax_message('Записан новый элемент' + data)
      else
        show_ajax_message('Успешно записан новый элемент')
  return

@delete_item = (url) -> 
  $.ajax
    url: url
    data: '_method': 'delete'
    dataType: 'script'
    type: 'POST'
    complete: ->
      # $.get url, null, null, 'script'
      show_ajax_message('Успешно удалено')
      return
  return

@enableControls = (items, checked, level = 3) ->
  items.children().each ->
    # console.log('$(this)', $(this)) 
    $(this).prop('readonly', checked)
    v = $(this).val()
    if $(this).hasClass('chosen') || $(this).hasClass('datepicker') || v=='true' || v=='false'
      $(this).prop('disabled', checked).trigger("chosen:updated")
    # if $(this)
    if checked then $(this).addClass('disabled') 
    else $(this).removeClass('disabled')
    if $(this).children().length >0 && level >0
      enableControls($(this), checked, level-1)


$(document).ready -> 
 $(document).on 'dblclick', '.tleads td', ->
  href = $(this).siblings('td.edit_delete').children('a.icon_edit').attr('href')
  if href!=undefined
    window.location.href = $(this).siblings('td.edit_delete').children('a.icon_edit').attr('href')


 $(document).on 'click', '.sw_enable', ->
  grp_id = $(this).attr('grp_id')
  ch = $(this).find('.checkbox').hasClass('active')
  #$('.grp'+grp_id).prop('readonly',ch)
  $('.grp'+grp_id).prop('readonly',ch)
  enableControls($('.grp'+grp_id), ch)
  # $('.grp'+grp_id).children().each ->
    # if ch then $(this).addClass('disabled') else $(this).removeClass('disabled')

 $('.page-wrapper').on 'click', 'span.role_check',  ->
    checked = switch_check($(this))    
    user_id = $(this).attr('user_id')
    role_id = $(this).attr('role_id')
    tr = $(this).closest('tr')
    
    data  ={'model': 'UserRole', 'item_id': user_id, 'field': role_id,'checked': checked}
    switch_check_ajax(data,tr,'')
    return   
 $(document).on 'click', 'span.sw_check',  ->
  model = $(this).parents('table').attr('model')
  checked = switch_check($(this))
    
  item_id = $(this).attr('item_id')
  chk = $(this).attr('chk')
  tr = $(this).closest('tr')
  
  table = $(this).closest('table')
  color_cls = table.attr('color_cls')
  if !chk
    chk = table.find('th:eq('+$(this).closest('td')[0].cellIndex+')').attr('fld')
  data  ={'model': model, 'item_id': item_id, 'field': chk,'checked': checked}
  switch_check_ajax(data,tr,color_cls)
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
  save_item($(this))

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
    attr_url = $(this).closest('table').attr('id') 
    if attr_url!=undefined
      del_url = '/'+attr_url + '/' + item_id
    else
      del_url = url + '/' + item_id
    if url.indexOf('edit')<1 && url.indexOf('options')<1 then url = url + '/edit'
   # url = url.replace('options/','')  
    del = confirm('Действительно удалить?')
    if !del
      return
    delete_item(del_url)

