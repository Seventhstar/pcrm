# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@update_clients = (cl_id)->
  $.get '/clients/'+cl_id+'/edit', "", null, "script"
  return

@clients_query = ->
  params = $("#cl_search").serialize()
  $.get 'clients', params, null, 'script'
  setLoc("clients?"+params)

$(document).ready ->
	$('#cl_search').on 'keyup', '#search', ->    
    clients_query()
    return