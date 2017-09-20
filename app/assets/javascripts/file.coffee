# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@update_owner = (owner,id) ->
  $.get '/'+owner+'/'+id+'/edit', "", null, "script"
  return

$(document).ready ->

  $('#attach_list').fileupload
    formData: owner_id: $('#attach_list').attr('owner_id'), owner_type: $('#attach_list').attr('owner_type')
    url: 'files'
    pasteZone: null
    done: (e, data) ->
      owner_id = $('#attach_list').attr('owner_id')
      owner_type = $('#attach_list').attr('owner_type')
      #setTimeout 'update_owner("'+owner_type+'",'+owner_id+')',200
      $('.progress').hide()
      return
    progressall: (e, data) ->
      progress = parseInt(data.loaded / data.total * 100, 10)
      $('.progress').show()
      $('.progress-bar').css width: progress + '%'
      $('.progress-bar span').text progress + '%'
      return
