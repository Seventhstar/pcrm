@stats_query = ->
  p_params = $("#stats_page").serialize()
  $.get 'statistics', p_params, null, 'script'
  setLoc("statistics?"+p_params)

jQuery ->
  chosen_params = {width: '270px'}
  $('#page_type').chosen(chosen_params).on 'change', ->
    stats_query()
  
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
  
  if (data_container.attr('element') == 'Area') then  Morris.Area(config)  else Morris.Bar(config) 