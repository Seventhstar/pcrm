# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->

  $('#style').chosen(width: '240px', disable_search: true).on 'change', ->
  	$.get 'providers', $("#p_search").serialize(), null, 'script'


  $('#budget').chosen(width: '240px', disable_search: true).on 'change', ->
    $.get 'providers', $("#p_search").serialize(), null, 'script'
  
  $('#goodstype').chosen(width: '240px', disable_search: true).on 'change', ->
    $.get 'providers', $("#p_search").serialize(), null, 'script'
    
  $('.chosen-select').chosen({width: '402px', display_selected_options: false, display_disabled_options:false,placeholder_text_multiple: 'Выберите...'})
  	