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

  $('.container').on 'keyup', '#search', ->
    search = $('.container #search').val()
    srt = $('.subnav .active').attr('sort')
    dir = $('.subnav .active').attr('direction')
    actual = $('.only_actual').hasClass('active')
    #alert(search)
    $.get 'leads', {
        only_actual: actual
        direction: dir
        sort: srt
        search: search
    }, null, 'script'

  $('.container').on 'click', 'span.sort-span', ->
    srt = $(this).attr('sort')
    #//alert(srt)
    dir = $(this).attr('direction')
    actual = $('.only_actual').hasClass('active')
    search = $('.container #search').val()

    if $(this).hasClass('active')
      dir = if dir == 'asc' then 'desc' else 'asc'
      $(this).attr('direction',dir)
    else
      $('.sort-span').removeClass('active')
      $(this).addClass('active')

      url = {
        only_actual: actual
        direction: dir
        sort: srt
        search: search
    }
    $.get 'leads', url, null, 'script'
    setLoc("leads?so"+url);
    return

  $('.container').on 'click', 'span.subsort', ->
    sort2 = $(this).attr('sort2')
    alert(sort2)
    dir2 = $(this).attr('dir2')
    srt = $('span.active').attr('sort');

    dir = $('span.active').attr('direction')
    actual = $('.only_actual').hasClass('active')
    search = $('.container #search').val()

    url = {
        only_actual: actual
        sort: srt
        direction: dir
        sort_2: sort2
        dir_2: dir2
        search: search
    }
    

    $.get 'leads', url, null, 'script'
    
    setLoc("leads?sort="+srt + "&direction="+dir+"&sort2="+sort2+"&dir2="+dir2);
    return


  $('.container').on 'click', 'span.only_actual', ->
    srt = $('.subnav .active').attr('sort')
    dir = $('.subnav .active').attr('direction')
    search = $('.container #search').val()
    if $(this).hasClass('active')
      actual = false
      $(this).removeClass('active')
      $(this).text('Все')
    else 
      actual = true
      $(this).addClass('active')
      $(this).text('Актуальные')
    $.get 'leads', {
        only_actual: actual
        direction: dir
        sort: srt
        search: search
    }, null, 'script'
    

  
    