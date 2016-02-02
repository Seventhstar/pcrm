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

  chosen_params = {width: '370px', allow_single_deselect: true}
  $('#goodstype').chosen(chosen_params ).on 'change', ->
    provider_query()

  $('.chosen-select').chosen({width: '452px', display_selected_options: false, display_disabled_options:false})

  $('#provider_p_status_id').chosen({width: '452px', display_selected_options: false, display_disabled_options:false})

  	
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

