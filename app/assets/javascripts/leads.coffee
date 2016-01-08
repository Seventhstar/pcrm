# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@addParam = (url, param, value) ->
  a = document.createElement('a')
  regex = /[?&]([^=]+)=([^&]*)/g
  match = undefined
  str = []
  a.href = url
  value = value or ''
  while match = regex.exec(a.search)
    if encodeURIComponent(param) != match[1]
      str.push match[1] + '=' + match[2]
  str.push encodeURIComponent(param) + '=' + encodeURIComponent(value)
  a.search = (if a.search.substring(0, 1) == '?' then '' else '?') + str.join('&')
  a.href

@update_Lead = (lead_id)->
#  alert 'leadid'+lead_id
  $.get '/leads/'+lead_id+'/edit', "", null, "script"

@add_comment = ->
  comment_id = $('.microposts p:first').attr('ownerid')
  comment = $('#comment_comment').val()
  owner_id = $('#btn-chat').attr('ownerid')
  owner_type = $('#btn-chat').attr('ownertype');
  upd_url = owner_type.toLowerCase()+'s';
  if comment == ''
    return
  #return;
  $.ajax
    url: '/ajax/add_comment'
    data:
      'comment': comment
      'owner_id': owner_id
      'owner_type': owner_type
    type: 'POST'
    beforeSend: (xhr) ->
      xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
      return
    success: ->
      $('#comment_comment').val ''
      $.get '/'+upd_url+'/' + owner_id + '/edit', '', null, 'script'
      #$('.panel-body').scrollTop(-9999);
      return
  return

@sortable_query = (params)->
  actual = if $('.only_actual').length==0 then null else $('.only_actual').hasClass('on')

  url = {    
    only_actual: actual
    sort: $('span.active').attr('sort')
    direction: $('span.active').attr('direction')
    sort2: $('span.subsort.current').attr('sort2')
    dir2: $('span.subsort.current').attr('dir2')
    search: $('#search').val()
  }
  
  each params, (i, a) ->
    url[i] = a

  each url, (i, a) -> 
    if a == undefined || a == null || a == ''
       delete url[i] 
  
  method = if $('#cur_method').val() == 'edit_multiple' then '/edit_multiple' else ''
  controller = $('#search').attr('cname')

  $.get '/'+controller+method, url, null, 'script'
  setLoc(""+controller+method+"?"+ajx2q(url));
  return

$(document).ready ->

  #$('#lead_channel_id').chosen(width: '352px', disable_search: 'true')
  $('#lead_channel_id').chosen(width: '99.5%', disable_search: 'true')
  $('#lead_status_id').chosen(width: '99.5%', disable_search: 'true')
  $('.inp_w #lead_user_id').chosen(width: '99.5%', disable_search: 'true')
  $('.inp_w #lead_ic_user_id').chosen(width: '99.5%', disable_search: 'true')
  
  
  $('#user_id').chosen(width: '200px', disable_search: 'true')

  # удаляем комент
  $('.comments_box').on 'click', 'span.btn_remove', ->
    del = confirm('Действительно удалить?')
    if !del
      return
    ownerid = $(this).attr('ownerid')
    comm_id = $(this).attr('commentid')
    owner_type = $('#btn-chat').attr('ownertype');
    upd_url = owner_type.toLowerCase()+'s';
    $.ajax
      url: '/ajax/del_comment'
      data: 'comment_id': comm_id
      type: 'POST'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
        return
      success: ->
        $.get '/'+upd_url+'/' + ownerid + '/edit', '', null, 'script'
        show_ajax_message "Успешно удален"
        return
    return

  # добавление комментария 
  # кликом по кнопке 
  $('.comments_box').on 'click', 'span.btn-sm', ->
    add_comment()
    return
  
  # нажатием на Enter
  $('.container').on 'keypress', '#comment_comment', ->
    if event.keyCode==13
      add_comment()
      return false;
    return

  # поиск 
  $('#search').on 'keyup', (e)-> 
    #alert e.which
    c= String.fromCharCode(event.keyCode);
    isWordCharacter = c.match(/\w/);
    isBackspaceOrDelete = (event.keyCode == 8 || event.keyCode == 46);
    if (isWordCharacter || isBackspaceOrDelete)
       delay('sortable_query({})',700)
    return

  # основновная сортировка
  $('.container').on 'click', 'span.sort-span', ->
    #alert(12)
    srt = $(this).attr('sort')
    dir = $(this).attr('direction')

    if $(this).hasClass('active')
      dir = if dir == 'asc' then 'desc' else 'asc'
      $(this).attr('direction',dir)
    else
      $('.sort-span').removeClass('active')
      $(this).addClass('active')
    sortable_query({sort2: srt,dir2:dir})
    return

  # сортировка 2го уровня
  $('.container').on 'click', 'span.subsort', ->
    dir2 = $(this).attr('dir2')
    srt2 = $(this).attr('sort2')
    if $(this).hasClass('current')
      dir2 = if dir2 == 'asc' then 'desc' else 'asc'
    sortable_query({sort2:srt2,dir2:dir2})
    return

  # вкл/откл лидов с неактуальными статусами
  #$('.container').on 'click', '.only_actual, .switcher_a', ->
  #  alert('dd')
  #  if $(this).hasClass('active')
  #    $(this).removeClass('active')
  #    $(this).text('Все')
  #    actual = false
  #  else 
  #    $(this).addClass('active')
  #    $(this).text('Актуальные')
  #    actual = true
  #  lead_query({only_actual:actual})
    return