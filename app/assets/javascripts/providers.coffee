# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $('#style').chosen().on 'change', ->
    $.get 'providers', $("#p_search").serialize(), null, 'script'
  $('#budget').chosen(width: '200px').on 'change', ->
    $.get 'providers', $("#p_search").serialize(), null, 'script'
  $('#goodstype').chosen(width: '200px').on 'change', ->
    $.get 'providers', $("#p_search").serialize(), null, 'script'
    
  $(".chosen-select").chosen({ width: '350px', placeholder_text_multiple: 'Выберите...' });