jQuery ->
  data_container = $('#leads_chart')
  if data_container.attr('leads') == undefined then return
  Morris.Bar
    element: 'leads_chart'
    data: jQuery.parseJSON(data_container.attr('leads')),
    xkey: 'value'
    ykeys: ['start_date','status_date','created_at']
    labels: jQuery.parseJSON(data_container.attr('headers'))
  data_container = $('#leads_users_chart')
  Morris.Bar
    element: 'leads_users_chart'
    data: jQuery.parseJSON(data_container.attr('leads')),
    xkey: 'month'
    ykeys: ['user','status_date','created_at']
    labels: jQuery.parseJSON(data_container.attr('headers'))

