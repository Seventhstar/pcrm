@stats_query = ->
  p_params = $("#stats_page").serialize()
  $.get 'pages', p_params, null, 'script'
  setLoc("pages?"+p_params)

jQuery ->
  chosen_params = {width: '270px'}
  $('#page_type').chosen(chosen_params).on 'change', ->
    stats_query()
  
  data_container = $('#leads_chart')
  if data_container.attr('leads') == undefined then return
  config = 
    element: 'leads_chart'
    data: jQuery.parseJSON(data_container.attr('leads')),
    xkey: 'month'
    ykeys: jQuery.parseJSON(data_container.attr('headers'))
    labels: jQuery.parseJSON(data_container.attr('headers'))
    parseTime: false
  
  if (data_container.attr('element') == 'Area') then  Morris.Area(config)  else Morris.Bar(config) 