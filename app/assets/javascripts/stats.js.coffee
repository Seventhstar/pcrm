@stats_query = ->
  p_params = $("#stats_page").serialize()
  $.get 'statistics', p_params, null, 'script'
  setLoc("statistics?"+p_params)

@create_chart = (add = '')->
  data_container = $('#data_chart' + add)
  if data_container.attr('data') == undefined then return
  headers = jQuery.parseJSON(data_container.attr('headers'))

  config = 
    element: "data_chart"+add
    data: jQuery.parseJSON(data_container.attr('data')),
    xkey: data_container.attr('xkey')
    ykeys: headers
    labels: headers
    resize: true
    behaveLikeLine: true    
    parseTime: false
  
  switch data_container.attr('element')
    when 'Area'
      Morris.Area config
    when 'Bar'
      Morris.Bar config
    when 'Donut'
      Morris.Donut config

jQuery ->
  chosen_params = {width: '270px'}
  $('#page_type').chosen(chosen_params).on 'change', ->
    stats_query()
  create_chart()
  create_chart(2)
  
