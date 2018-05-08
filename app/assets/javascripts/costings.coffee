# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('#costing_project_address').autocomplete
    source: "/ajax/projects"
    select: (event,ui) ->
      $("#costing_project_id").val(ui.item.id)
    change: (event, ui) ->
      return
      $("#costing_project_id").val(null)