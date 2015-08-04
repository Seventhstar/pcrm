jQuery ->
  #alert(JSON.parse("[{\"value\":\"February\",\"count\":8}]"))
#  alert($('#leads_chart').attr('leads'))	
#  alert(JSON.parse($('#leads_chart').attr('leads')))	

  Morris.Bar
    element: 'leads_chart'
    data: jQuery.parseJSON($('#leads_chart').attr('leads')),
    xkey: 'value'
    ykeys: ['count']
    labels: ['Лидов']

