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

@update_lead = (lead_id)->
#  alert 'leadid'+lead_id
  $.get '/leads/'+lead_id+'/edit', "", null, "script"

@lead_query = (lead_params)->
  sort2 = $('span.subsort.current').attr('sort2')
  dir2 = $('span.subsort.current').attr('dir2')
  srt = $('span.active').attr('sort');
  dir = $('span.active').attr('direction')
  actual = $('.only_actual').hasClass('active')
  search = $('.container #search').val()

  url = {
    only_actual: actual
    sort: srt
    direction: dir
    sort2: sort2
    dir2: dir2
    search: search
  }

  each lead_params, (i, a) ->
  	url[i] = a

  $.get 'leads', url, null, 'script'

  setLoc("leads?"+ajx2q(url));
  return

$(document).ready ->

  $('#lead_channel_id').chosen(width: '402px', disable_search: 'true')
  $('#lead_status_id').chosen(width: '402px', disable_search: 'true')

  $('#basic1').fileupload
    done: (e, data)->
      #console.log "Done", data.result
      #$("body").append(data.result)
      #$('.files').
      #$.get('/leads/'+lead_id+'/edit', "", null, "script");

  $('#file').fileupload

    formData: leadid: $('#file').attr('leadid')
    url: @importUrl
    pasteZone: null
    done: (e, data) ->
      lead_id = $('#file').attr('leadid')
      setTimeout 'update_lead('+lead_id+')',200
      $('.progress').hide()
      return
    progressall: (e, data) ->
      progress = parseInt(data.loaded / data.total * 100, 10)
      $('.progress').show()
      $('.progress-bar').css width: progress + '%'
      return

  $('.files').on 'click', 'span.glyphicon-remove', ->
    file_id = $(this).attr('file_id')
    del = confirm('Действительно удалить?')
    if !del
       return
    $.ajax
      url: '/ajax/del_file'
      data: 'file_id': file_id
      type: 'POST'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
        return
      success: ->
        lead_id = $('#file').attr('leadid')
        setTimeout 'update_lead('+lead_id+')',200
        show_ajax_message "Успешно удален"
        return
    return

  $('.comments_box').on 'click', 'span.btn_remove', ->
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

  # поиск 
  $('.container').on 'keyup', '#search', ->
    search = $('.container #search').val()
    lead_query({})
    return

  # основновная сортировка
  $('.container').on 'click', 'span.sort-span', ->
    srt = $(this).attr('sort')
    dir = $(this).attr('direction')

    if $(this).hasClass('active')
      dir = if dir == 'asc' then 'desc' else 'asc'
      $(this).attr('direction',dir)
    else
      $('.sort-span').removeClass('active')
      $(this).addClass('active')
    lead_query({})
    return

  # сортировка 2го уровня
  $('.container').on 'click', 'span.subsort', ->
    dir2 = $(this).attr('dir2')
    srt2 = $(this).attr('sort2')
    if $(this).hasClass('current')
      dir2 = if dir2 == 'asc' then 'desc' else 'asc'
    lead_query({sort2:srt2,dir2:dir2})
    return

  # вкл/откл лидов с неактуальными статусами
  $('.container').on 'click', 'span.only_actual', ->
    if $(this).hasClass('active')
      $(this).removeClass('active')
      $(this).text('Все')
      actual = false
    else 
      $(this).addClass('active')
      $(this).text('Актуальные')
      actual = true
    lead_query({only_actual:actual})
    return

  
    