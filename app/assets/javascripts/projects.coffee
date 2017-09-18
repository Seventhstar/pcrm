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

  d_price  = intFromSum($('#project_designer_price').val())
  d_price2 = intFromSum($('#project_designer_price_2').val())
  v_price  = intFromSum($('#project_visualer_price').val())
  designer_sum = ( d_price * footage ) / 10
  designer_sum2 = ( d_price2 * footage2 ) / 10
  visual_sum   = ( v_price * footage) / 10
  
  if d_price>0
    $('#project_designer_sum').val(to_sum(designer_sum + designer_sum2))
  else
    designer_sum = intFromSum($('#project_designer_sum').val())
    designer_sum2 = 0    

  if v_price>0
    $('#project_visualer_sum').val(to_sum(visual_sum))
  else
    visual_sum = intFromSum($('#project_visualer_sum').val())
  
  if (designer_sum>0)
    $('#project_sum_total_executor').val( to_sum( designer_sum + designer_sum2 + visual_sum) )
    ex_sum = designer_sum + designer_sum2 + visual_sum
  else
    ex_sum = intFromSum($('#project_sum_total_executor').val())
  $('#project_sum_rest').val( to_sum(intFromSum($('#project_sum_total').val()) - ex_sum) )
  return

$(document).ready ->
  $(document).on 'click', '.inline_edit', ->
    disable_input_row()
    itm = $(this).attr('item_id')
    $('#edit_pgt_item'+itm).show()
    $('#pgt_item'+itm).hide()
  $(".container").on 'click','span.btn_add', ->
    disable_input_row()
    id = $(this).attr('itm')
    $('#'+id).show()
    $('#table_'+id+' .hidden').removeClass('hidden')
    $(this).hide()
    # $('#table_'+id+'.fw input').focus()
    $('#table_' + id + ' .new_row input')[1].focus()

  $(".container").on 'change','#project_pstatus_id', ->
    $('#project_progress').val(0)

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
  $('#project_project_type_id,#project_executor_id,#project_style_id').chosen
    width: '99.5%'
    disable_search: 'true'
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
  $('#project_price,#project_footage,#project_price_2,#project_footage_2').change ->
    calc_proj_sum()
    calc_executor_sum()
  $('#project_price_real,#project_price_2_real,#project_footage_2_real,#project_footage_real').change ->
    calc_proj_sum_real()
  $('#project_sum_2_real').change ->
    calc_proj_sum_real()
  $('#project_sum_real').change ->
    calc_proj_sum()
  $('#project_sum_total,#project_sum_total_real').change ->
    calc_debt()
  $('#project_sum_total_executor').change ->
    $('#project_sum_rest').val( to_sum(intFromSum($('#project_sum_total').val()) - intFromSum($(this).val())) )
  $('#project_designer_price,#project_designer_price_2,#project_visualer_price,#project_designer_sum,#project_visualer_sum').change ->
    calc_executor_sum()
    return
  return
