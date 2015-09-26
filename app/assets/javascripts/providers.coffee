# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@update_provider = (p_id)->
  $.get '/providers/'+p_id+'/edit', "", null, "script"
  return

@provider_query = ->
  p_params = $("#p_search").serialize()
  $.get 'providers', p_params, null, 'script'
  setLoc("providers?"+p_params)

$(document).ready ->

  chosen_params = {width: '170px', allow_single_deselect: true, placeholder_text_single: 'Стиль...'}

  $('#style').chosen(chosen_params).on 'change', ->
    provider_query()
  	#$.get 'providers', $("#p_search").serialize(), null, 'script'

  chosen_params.placeholder_text_single = 'Бюджет...'
  $('#budget').chosen(chosen_params).on 'change', ->
    provider_query()
    #$.get 'providers', $("#p_search").serialize(), null, 'script'
  
  $('#goodstype').chosen(chosen_params ).on 'change', ->
    provider_query()
    #$.get 'providers', $("#p_search").serialize(), null, 'script'

  $('#p_status').chosen(chosen_params).on 'change', ->
    provider_query()
    #$.get 'providers', $("#p_search").serialize(), null, 'script'

  

  $('.chosen-select').chosen({width: '452px', display_selected_options: false, display_disabled_options:false})

  $('#provider_p_status_id').chosen({width: '452px', display_selected_options: false, display_disabled_options:false})

    # поиск 
  $('#p_search').on 'keyup', '#search', ->    
    provider_query()
    return

  	
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
    pm_id = $(this).attr('item_id')
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
