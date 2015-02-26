# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $('#style').select2(width: '200px').on 'change', ->
    #$alert(12);
    $.get 'providers', $("#p_search").serialize(), null, 'script'
    
