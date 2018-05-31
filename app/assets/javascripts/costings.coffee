# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('.autocomplete').autocomplete
    source: (request, response) ->
      $.getJSON "/ajax/autocomplete?model="+$(this.element).attr('model') + "&term=" + request.term, (data) ->
        response data
    select: (event,ui) ->
      $("#"+$(this).attr('hidden_id')).val(ui.item.id)
      return
    change: (event, ui) ->
      return



