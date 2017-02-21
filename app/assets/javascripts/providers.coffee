# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  $('#goodstype').chosen({width: '370px', allow_single_deselect: true} )
  $('.chosen-select').chosen({width: '452px', display_selected_options: false, display_disabled_options:false})
  	
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
        update_owner('providers',pr_id)
        return
     return

