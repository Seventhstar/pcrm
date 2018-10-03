# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@update_owner = (owner,id) ->
  $.get '/'+owner+'/'+id+'/edit', "", null, "script"
  return

$(document).ready ->
  $('#attach_list').fileupload
    formData:
      owner_id: $('#attach_list').attr('owner_id')
      owner_type: $('#attach_list').attr('owner_type')
    url: 'files'
    pasteZone: null
    done: (e, data) ->
      owner_id = $('#attach_list').attr('owner_id')
      owner_type = $('#attach_list').attr('owner_type')
      $('.progress').hide()
      return
    progressall: (e, data) ->
      progress = undefined
      progress = parseInt(data.loaded / data.total * 100, 10)
      $('.progress').show()
      $('.progress-bar').css width: progress + '%'
      $('.progress-bar span').text progress + '%'
      return
  $('.icon_lock').on 'click', ->
    $(this).toggleClass 'locked'
    li = $(this).closest('li')
    file_id = $(this).attr('file-id')
    $.ajax
      url: '/ajax/switch_locked'
      data: file: file_id
      type: 'POST'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
        return
      success: ->
        li.toggleClass 'locked'
        return
    return
