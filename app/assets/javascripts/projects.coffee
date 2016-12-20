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

@calculateDays = (d0, d1) ->
  ndays = 1 + Math.round((d1.getTime() - d0.getTime()) / (24 * 3600 * 1000))
  nsaturdays = Math.floor((ndays + d0.getDay()) / 7)
  ndays - (2 * nsaturdays) + (d0.getDay() == 6) - (d1.getDay() == 5)

@workday_count = (start, end) ->
  first = start.clone().endOf('week')   # end of first week
  alert (first)
  last = end.clone().startOf('week')   # start of last week
  days = last.diff(first, 'days') * 5 / 7   # this will always multiply of 7
  wfirst = first.day() - start.day()   # check first week
  if start.day() == 0
    --wfirst   # -1 if start with sunday
  wlast = end.day() - last.day()   # check last week
  if end.day() == 6
    --wlast   # -1 if end with saturday
  wfirst + days + wlast   # get the total

@changeDTP = (ptr,el) ->
	if ptr.name == 'project[date_end_plan]' or ptr.name == 'project[date_start]'
		d1 = dateFromString($('#project_date_start').val())
		d2 = dateFromString($('#project_date_end_plan').val())
		$('#days').val( moment(d1).isoWeekdayCalc(d2,[1,2,3,4,5]) )

		return

@calc_debt =() ->
  sum_total = intFromSum($('#project_sum_total').val())
  calc_sum_total = intFromSum($('#project_sum_2').val()) + intFromSum($('#project_sum').val())
  $('#project_sum_total').attr('title',sum_total)
  $('#project_sum_total').attr('title',sum_total)
  if calc_sum_total != sum_total
     $('#project_sum_total').addClass('red')
  else
     $('#project_sum_total').removeClass('red')
  sum_total_real = intFromSum($('#project_sum_total_real').val())
  calc_sum_total_real = intFromSum($('#project_sum_2_real').val()) + intFromSum($('#project_sum_real').val())
  if calc_sum_total_real != sum_total_real
     $('#project_sum_total_real').addClass('red')
  else
     $('#project_sum_total_real').removeClass('red')
  if sum_total_real!=0 then sum_total = sum_total_real
  $('#cl_debt').html(to_sum(sum_total-intFromSum($('#cl_total').html())))
  return

@fp_sum =(price, footage ) ->
  to_sum( intFromSum($(price).val()) * parseFloat($(footage).val()*10)/10 )

@calc_proj_sum =() ->
  $('#project_sum').val( fp_sum('#project_price','#project_footage'))
  $('#project_sum_2').val( fp_sum('#project_price_2','#project_footage_2'))
  $('#project_sum_total').val( to_sum(intFromSum($('#project_sum_2').val()) + intFromSum($('#project_sum').val())))

  calc_debt()
  return

@calc_proj_sum_real =() ->
  $('#project_sum_real').val( fp_sum('#project_price_real','#project_footage_real'))
  $('#project_sum_2_real').val( fp_sum('#project_price_2_real','#project_footage_2_real'))
  $('#project_sum_total_real').val( to_sum(intFromSum($('#project_sum_2_real').val()) + intFromSum($('#project_sum_real').val()) ))
  calc_debt()
  return

@calc_executor_sum =() ->
  footage = parseFloat($('#project_footage').val()*10)
  footage2 = parseFloat($('#project_footage_2').val()*10)
  designer_sum = (intFromSum($('#project_designer_price').val()) * footage ) / 10
  designer_sum2 = (intFromSum($('#project_designer_price_2').val()) * footage2 ) / 10
  visual_sum   = (intFromSum($('#project_visualer_price').val()) * footage) / 10
  $('#project_sum_total_executor').val( to_sum( designer_sum + designer_sum2 + visual_sum) )
  $('#project_sum_rest').val( to_sum(intFromSum($('#project_sum_total').val()) - designer_sum - designer_sum2 - visual_sum) )
  return

$(document).ready ->
  $('#project_client_id').change ->
    # подменяем id клиента и в ссылке на редактирование после выбора
    new_href = $('#client_link').attr('href').split('/')
    new_href[2] = $(this).val()
    $('#client_link').attr('href',new_href.join('/'))
  $("#tabs").tabs();# { active: 1}
  $('#add_footage').click ->
    $(this).hide()
    $('.invisible').removeClass('invisible')
    return
  $('#project_project_type_id').chosen
    width: '99.5%'
    disable_search: 'true'
  $('#project_executor_id').chosen
    width: '99.5%'
    disable_search: 'true'
  $('#project_style_id').chosen
    width: '99.5%'
    disable_search: 'true'
  $('#days').change ->
    d_st = dateFromString $('#project_date_start').val()
    add  = $(this).val()-1
    d = moment(d_st).isoAddWeekdaysFromSet
      'workdays': add
      'weekdays': [1,2,3,4,5]
      'exclusions': [ '2015-05-09' ]
    # d = dateFromString(, )
    dd = $.datepicker.formatDate('dd.mm.yy', new Date(d))
    $('#project_date_end_plan').val dd
  $('#project_price,#project_footage,#project_price_2,#project_footage_2').change ->
    calc_proj_sum()
  $('#project_price_real,#project_price_2_real,#project_footage_2_real,#project_footage_real').change ->
    calc_proj_sum_real()
  $('#project_sum_2_real').change ->
    calc_proj_sum_real()
  $('#project_sum_real').change ->
    calc_proj_sum()
  $('#project_sum_total').change ->
    calc_debt()
  $('#project_sum_total_real').change ->
    calc_debt()
  $('#project_designer_price,#project_designer_price_2,#project_visualer_price').change ->
    calc_executor_sum()
  return
