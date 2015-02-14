# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('#lead_channel_name').autocomplete
    source: "/ajax/channels"
    select: (event,ui) ->
      $("#lead_channel_id").val(ui.item.id)
    change: (event, ui) ->
       $("#lead_channel_id").val(null)


function change_store(select_tag){
  value1 = $(select_tag).val()
  $.ajax({
    url: "channels/mehuod_name",
    data: {data1: value1}
  })
 }
