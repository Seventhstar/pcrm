# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@dateFromString = (str, add =0) ->
        str = str.split('.');
        str = new Date(parseInt(str[2],10),parseInt(str[1], 10)-1,(parseInt(str[0]))+parseInt(add));
        return str

@DDMMYYYY = (str) ->
        ndateArr = str.toString().split(' ');
        Months = 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec';
        return (parseInt(Months.indexOf(ndateArr[1])/4)+1)+'.'+ndateArr[2]+'.'+ndateArr[3];

@changeDTP = (ptr,el) ->
  if ptr.name == 'project[date_end_plan]' or ptr.name == 'project[date_start]'
    d1 = dateFromString($('#project_date_start').val())
    d2 = dateFromString($('#project_date_end_plan').val())
    v  = $('#holidays').val().split(" ")
    $('#project_days').val( moment().isoWeekdayCalc(d1,d2,[1,2,3,4,5],v) )
    return

intPrjSum = (name) ->
  intFromSum($('#project_'+name).val())

@prjFloat = (name) ->
  parseFloat($("#project_"+name).val())

@updSumTotal = (sum, calc_sum_val, sum_val) ->
  _sum = $('#project_' +sum)
  _sum.attr('title', sum_val)
  if calc_sum_val != sum_val
     _sum.addClass('red')
  else
     _sum.removeClass('red')


calc_debt = ->
  sum_total = intPrjSum("sum_total")
  calc_sum_total = intPrjSum("sum") + intPrjSum("sum_2")
  
  updSumTotal('sum_total', calc_sum_total, sum_total)

  sum_total_real = intPrjSum('sum_total_real')
  calc_sum_total_real = intPrjSum('sum_2_real') + intPrjSum('sum_real')

  updSumTotal('sum_total_real', calc_sum_total_real, sum_total_real)
  
  if sum_total_real!=0 then sum_total = sum_total_real
  $('#cl_debt').html(to_sum(sum_total-intFromSum($('#cl_total').html())))
  return

fp_sum = (sum_name, price, footage) ->
  sum = to_sum( intPrjSum(price) * prjFloat(footage))
  if sum != "0" 
    $('#project_'+sum_name).val(sum)

@sum_total = (total, sum, sum2) ->
  ttl = to_sum(intPrjSum(sum) + intPrjSum(sum2))
  if ttl != "0"
    $('#project_'+total).val(ttl)

calcPrjSum = (suff) ->
  fp_sum('sum'+suff, 'price'+suff, 'footage'+suff)
  fp_sum('sum_2'+suff, 'price_2'+suff,'footage_2'+suff)
  sum_total('sum_total'+suff, 'sum'+suff, 'sum_2'+suff)
  calc_debt()
  return

calc_proj_sum_plan = ->
  calcPrjSum('')

calc_proj_sum_real = ->
  calcPrjSum('_real')  

calc_rest = (ex_sum)->
  # sum_total_real = intPrjSum('sum_total_real')
  # if sum_total_real > 0
  #   sum_total = sum_total_real
  # else
  #   sum_total = intPrjSum('sum_total')
  # if ex_sum == 0
  #   ex_sum = intPrjSum('sum_total_executor')
  # $('#project_sum_rest').val(to_sum(sum_total - ex_sum)) 

calc_executor_sum = ->
  footage = prjFloat('footage')
  footage2 = prjFloat('footage_2')
  v_price  = intPrjSum('visualer_price')
  d_price  = intPrjSum('designer_price')
  d_price2 = intPrjSum('designer_price_2') 
  visual_sum    = v_price * footage
  designer_sum  = d_price * footage 
  designer_sum2 = d_price2 * footage2 
  
  if d_price>0
    $('#project_designer_sum').val(to_sum(designer_sum + designer_sum2))
  else
    designer_sum = intPrjSum('designer_sum')
    designer_sum2 = 0    

  if v_price>0
    $('#project_visualer_sum').val(to_sum(visual_sum))
  else
    visual_sum = intPrjSum('visualer_sum')
  
  if (designer_sum>0)
    $('#project_sum_total_executor').val( to_sum( designer_sum + designer_sum2 + visual_sum) )
    ex_sum = designer_sum + designer_sum2 + visual_sum
  else
    ex_sum = intFromSum($('#project_sum_total_executor').val())
  calc_rest(ex_sum)
  return

totals_by_group = (g) ->
  gpr = g.attr('grp')
  total_offer = ''
  total_supply = ''
  $.each [['EUR','€'],['USD', '$'],['RUB','р.']], (i, v) ->
    sum_offer = 0
    sum_supply = 0
    g.find('.sum_' + v[0]).each ->
      sum_offer += intFromSum($(this).attr('sum_offer'))
      sum_supply += intFromSum($(this).attr('sum_supply'))
      return
    total_offer += to_sum(sum_offer) + v[1] if sum_offer>0
    total_offer += ', ' if i <2 && sum_offer>0
    total_supply += to_sum(sum_supply) + v[1] if sum_supply>0
    total_supply += ', ' if i <2 && sum_supply>0
  $('#total_offer_' + gpr).text total_offer
  $('#total_supply_' + gpr).text total_supply
  return

@calc_totals = ->
  grand_sum_offer = 0
  grand_sum_supply = 0
  $('.good_group').each ->  
    gpr = $(this).attr('grp')
    total_offer = ''
    total_supply = ''
    g = $(this)
    $.each [['EUR','€'],['USD', '$'],['RUB','р.']], (i, v) ->
      sum_offer = 0
      sum_supply = 0
      g.find('.sum_' + v[0]).each ->
        sum_offer += intFromSum($(this).attr('sum_offer'))
        sum_supply += intFromSum($(this).attr('sum_supply'))
        return
      grand_sum_offer += sum_offer
      total_offer += to_sum(sum_offer) + v[1] if sum_offer>0
      total_offer += ', ' if i <2 && sum_offer>0
      total_supply += to_sum(sum_supply) + v[1] if sum_supply>0
      total_supply += ', ' if i <2 && sum_supply>0
    $('#total_offer_' + gpr).text total_offer
    $('#total_supply_' + gpr).text total_supply
    # totals_by_group($(this))
  #   sum_offer += intFromSum($('#total_offer_' + gpr).attr('sum_offer'))
  #   sum_supply += intFromSum($('#total_supply_' + gpr).attr('sum_supply'))
  # $('#grand_supply').text sum_supply


$(document).ready ->
  calc_totals()
  $(document).on 'click', '.inline_edit', ->
    disable_input_row()
    itm = $(this).attr('item_id')
    $('#edit_pgt_item'+itm).show()
    $('#pgt_item'+itm).hide()

  $(".container").on 'change','#project_pstatus_id', ->
    $('#project_progress').val(100)

  $(".container").on 'blur','#project_progress', -> 
    v = $(this).val()
    if v >100
      $(this).val(100)   
    if v <0
      $(this).val(0)

  $('#project_payd_full,#project_payd_q').click ->
    f = $('#project_payd_full')
    q = $('#project_payd_q')

    if f.is(':checked') && $(this)[0]==f[0]
      $('#project_payd_q').attr('checked', false)
    else if q.is(':checked') && $(this)[0]==q[0]
      $('#project_payd_full').attr('checked', false)
    return

  $('#project_client_id').change ->
    # подменяем id клиента и в ссылке на редактирование после выбора
    new_href = $('#client_link').attr('href').split('/')
    new_href[2] = $(this).val()
    $('#client_link').attr('href',new_href.join('/'))
    #$("#tabs").tabs { active: 3}
  $('#add_footage').click ->
    $(this).hide()
    $('.invisible').removeClass('invisible')
    return
  
  $(document).on 'change', '#project_days', ->
    d_st = dateFromString $('#project_date_start').val()
    add  = $(this).val()-1
    v = $('#holidays').val().split(" ")
    d = moment(d_st).isoAddWeekdaysFromSet
      'workdays': add
      'weekdays': [1,2,3,4,5]
      'exclusions': v
    dd = $.datepicker.formatDate('dd.mm.yy', new Date(d))
    $('#project_date_end_plan').val dd
  $('#project_price, #project_footage, #project_price_2, #project_footage_2').change ->
    calc_proj_sum_plan()
    calc_executor_sum()
  $('#project_price_real, #project_price_2_real, #project_footage_2_real, #project_footage_real').change ->
    calc_proj_sum_real()
    calc_debt()
    calc_rest(0)
  $('#project_sum, #project_sum_2').change ->
    calc_proj_sum_plan()
    calc_debt()
    calc_rest(0)
  $('#project_sum_real, #project_sum_2_real').change ->
    calc_proj_sum_real()
    calc_debt()
    calc_rest(0)
  $('#project_sum_total,#project_sum_total_real').change ->
    calc_debt()
  $('#project_sum_total_executor').change ->
    $('#project_sum_rest').val( to_sum(intFromSum($('#project_sum_total').val()) - intFromSum($(this).val())) )
  $('#project_designer_price, #project_designer_price_2, #project_visualer_price, #project_designer_sum, #project_visualer_sum').change ->
    # calc_executor_sum()
    return
  return
