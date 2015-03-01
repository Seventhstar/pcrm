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



$(document).ready ->

  $('#lead_channel_id').chosen()
  $('#lead_status_id').chosen()
  

  $('.microposts').on 'click', 'span.glyphicon-remove', ->
    # alert('del');
    del = confirm('Действительно удалить?')
    if !del
      return
    lead_id = $(this).attr('leadid')
    leadcomm_id = $(this).attr('leadcommentid')
    $.ajax
      url: '/ajax/del_comment'
      data: 'lead_comment_id': leadcomm_id
      type: 'POST'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
        return
      success: ->
        $.get '/leads/' + lead_id + '/edit', '', null, 'script'
        show_ajax_message "Успешно удален"
        return
    return

  $('.container').on 'click', 'span.sort-span', ->
    srt = $(this).attr('sort')
    dir = $(this).attr('direction')
    actual = $('.only_actual').hasClass('active')
    $.get 'leads', {
        only_actual: actual
        direction: dir
        sort: srt
    }, null, 'script'
    

  $('.container').on 'click', 'span.only_actual', ->
    srt = $('.subnav .active').attr('sort')
    dir = $('.subnav .active').attr('direction')
    if $(this).hasClass('active')
      actual = false
    else 
      actual = true
    $.get 'leads', {
        only_actual: actual
        direction: dir
        sort: srt
    }, null, 'script'
    

  
    