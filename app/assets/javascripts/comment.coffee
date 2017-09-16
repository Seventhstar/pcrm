# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('.comments_box').on 'click', '.info', ->
    item = $(this).closest('.item')  
    $.ajax
      url: '/comments/read_comment'
      dataType: "json"
      data:
        'id': item.attr('commentid')
      type: 'POST'
      success: ->
        item.toggleClass('new')
    return


