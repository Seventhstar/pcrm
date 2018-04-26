# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
add_comment =(item) ->
  obj = item.attr('data-class')
  body = item.attr('data-body')
  msg = $("#"+obj+"_"+body).val()
  inputs = $('input[name^='+obj+']').serialize()
  if msg == ''
    return
  $.ajax
    url: '/'+obj+'s/'
    data: inputs
    dataType: 'script'
    type: 'POST'
    beforeSend: (xhr) ->
      xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
      return
  return

$ ->
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
    add_comment($(this))
    return
  
  # нажатием на Enter
  $('.container').on 'keypress', '#comment_comment, #special_info_content', ->
    if event.keyCode==13
      add_comment($($(this).attr('btn')))
      return false;
    return

  $('.comments_box').on 'click', '.info', ->
    item = $(this).closest('.item')  
    $.ajax
      url: '/comments/read_comment'
      dataType: "json"
      data:
        'id': item.attr('commentid')
      type: 'POST'
      success: ->
        item.toggleClass('new')
    return