# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@get_child_wiki = (p_id)->
	#/wiki_records/1/wiki_records
  $.get '/wiki_records/'+p_id+'/wiki_records', "", null, "script"
  return

@update_WikiRecord = (id)->
  $.get '/wiki_records/'+id+'/edit', "", null, "script"
  return

jQuery ->
  $('.container').on 'click', 'span.folder, .wiki_name span',->
    $(this).toggleClass 'opened'
    itm_id = $(this).parents('td').attr('item')    
    $('#sub'+itm_id).toggleClass('hidden')
    $('#files'+itm_id).toggleClass('hidden')
    if ($('#chitem_'+itm_id).html() =='') 
    	get_child_wiki(itm_id)
    $('#chitem_'+itm_id).toggleClass('hidden')
    return
  $('.container').on 'dblclick', '.wiki_name span',->
  	id = $(this).closest('.wiki_name').attr('item')
  	window.location.href = '/wiki_records/'+id+'/edit'
  chosen_params = width: '100%'
  $('#wiki_record_parent_id').chosen(chosen_params).on 'change', ->
    stats_query()
    return
  return