# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('span.folder').on 'click', ->
    $(this).toggleClass 'opened'
    return
  chosen_params = width: '100%'
  $('#wiki_record_parent_id').chosen(chosen_params).on 'change', ->
    stats_query()
    return
  return