@history_query = ->
  h_params = {user_id : $('#obj_user_id :selected').val(), type : $('#obj_type :selected').text()}
  $.get 'history', h_params, null, 'script'
  setLoc("history?"+ajx2q(h_params))

$(document).ready ->
  
  chosen_params = {width: '170px'}
  
  $('#obj_type').chosen(chosen_params).on 'change', ->
    history_query()

  $('#obj_user_id').chosen(chosen_params).on 'change', ->
    history_query()
