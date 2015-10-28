# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready ->

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
      $('.progress-bar span').text progress + '%'
      return


  $('#dev_file').fileupload
    formData: devid: $('#dev_file').attr('devid')
    url: @importUrl
    pasteZone: null
    done: (e, data) ->
      dev_id = $('#dev_file').attr('devid')
      setTimeout 'update_dev('+dev_id+')',200
      $('.progress').hide()
      return
    progressall: (e, data) ->
      progress = parseInt(data.loaded / data.total * 100, 10)
      $('.progress').show()
      $('.progress-bar').css width: progress + '%'
      $('.progress-bar span').text progress + '%'
      return

  $('#wiki_file').fileupload
    formData: ownerid: $('#wiki_file').attr('ownerid'), cls: 'wiki'
    url: @importUrl
    pasteZone: null
    done: (e, data) ->
      owner_id = $('#wiki_file').attr('ownerid')

      #setTimeout 'update_dev('+dev_id+')',200
      $('.progress').hide()
      return
    progressall: (e, data) ->
      progress = parseInt(data.loaded / data.total * 100, 10)
      $('.progress').show()
      $('.progress-bar').css width: progress + '%'
      $('.progress-bar span').text progress + '%'
      return

  # удаляем файл
  $('.box_wide').on 'click', 'span.icon_remove_1', ->
    file_id = $(this).attr('file_id')
    type_file = if $('#dev_file').length == 1 then 'dev' else 'leads'

    del = confirm('Действительно удалить?')
    if !del
       return
    $.ajax
      url: '/file/del_file'
      data: 'file_id': file_id, type: type_file
      type: 'POST'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
        return
      success: ->
        if type_file == 'leads'
          lead_id = $('#file').attr('leadid')
          setTimeout 'update_lead('+lead_id+')',200
        else
          dev_id = $('#dev_file').attr('devid')
          setTimeout 'update_dev('+dev_id+')',200
        
        show_ajax_message "Успешно удален"
        return
    return      