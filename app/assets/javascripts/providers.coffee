# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('#provider_style_tokens').tokenInput '/styles.json'
    theme: 'facebook'
    prePopulate: $('#provider_style_tokens').data('load')
