# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@update_provider = (p_id)->
  $.get '/providers/'+p_id+'/edit', "", null, "script"
  return

$(document).ready ->

  $('#style').chosen(width: '180px').on 'change', ->
  	$.get 'providers', $("#p_search").serialize(), null, 'script'

  $('#budget').chosen(width: '180px').on 'change', ->
    $.get 'providers', $("#p_search").serialize(), null, 'script'
  
  $('#goodstype').chosen(width: '180px').on 'change', ->
    $.get 'providers', $("#p_search").serialize(), null, 'script'

  $('#p_status').chosen(width: '180px').on 'change', ->
    $.get 'providers', $("#p_search").serialize(), null, 'script'

  

  $('.chosen-select').chosen({width: '402px', display_selected_options: false, display_disabled_options:false})

  $('#provider_p_status_id').chosen({width: '402px', display_selected_options: false, display_disabled_options:false})

  
  	
  $('.page-wrapper').on 'click','.managers #btn-send', ->
    pr_id = $(this).attr('providerid')
    inputs = $('input[name^=manager]')
    $.ajax
      url: '/ajax/add_provider_manager'
      data: inputs.serialize()+"&provider_id="+pr_id
      type: 'POST'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
        return
      success: ->
        update_provider(pr_id)
        return
     return

  # удаляем менеджера
  $('.page-wrapper').on 'click', '#pmanagers span.icon_remove', ->
    pr_id = $('#btn-send').attr('providerid')
    del = confirm('Действительно удалить?')
    if !del
      return
    pm_id = $(this).attr('providermanager_id')
    $.ajax
      url: '/ajax/del_provider_manager'
      data: 'p_id': pm_id
      type: 'POST'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
        return
      success: ->
        update_provider(pr_id)
        return
    return
