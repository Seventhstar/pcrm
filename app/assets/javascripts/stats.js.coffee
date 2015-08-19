@stats_query = ->
  p_params = $("#stats_page").serialize()
  $.get 'statistics', p_params, null, 'script'
  setLoc("statistics?"+p_params)

@create_chart =->
  data_container = $('#leads_chart')
  if data_container.attr('leads') == undefined then return
  headers = jQuery.parseJSON(data_container.attr('headers'))
  config = 
    element: 'leads_chart'
    data: jQuery.parseJSON(data_container.attr('leads')),
    xkey: 'month'
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
  
  