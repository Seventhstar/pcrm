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

$ ->
  receive_data =(data) ->
    console.log data
    $('.comments_list_a').append( Mustache.to_html($('#comments_template').html(), data))
    # $('#' + data.comment.commentable_type.toLowerCase() + '-' + data.comment.commentable_id + '-comments').append JST['templates/comment'](data)

  if gon.owner_id

  else
    App.cable.subscriptions.create('CommentsChannel', {
      connected: ->
        console.log 'Connected to comments!'
        @perform 'follow_all'
      ,

      received: (data) ->
        receive_data(data)
    })



