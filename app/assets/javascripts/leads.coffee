# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
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

