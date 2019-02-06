# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  $('#goodstype').chosen({width: '370px', allow_single_deselect: true} )
  $('.chosen-select').chosen({width: '458px', display_selected_options: false, display_disabled_options:false})
    
