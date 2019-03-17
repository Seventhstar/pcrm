# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@dateFromString = (str, add =0) ->
        str = str.split('.');
        str = new Date(parseInt(str[2],10), parseInt(str[1], 10)-1, (parseInt(str[0]))+parseInt(add));
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
    w  = $('#workdays').val().split(" ")
    $('#project_days').val( moment().isoWeekdayCalc(d1, d2, [1,2,3,4,5], v, w))
    return

$(document).ready ->
  $(document).on 'click', '.basket', ->
    g_id = $(this).attr('g_id')
    if g_id != undefined
      $('#attach_list').attr 'owner_id', g_id
      $('#attach_list').attr 'owner_type', 'ProjectGood'
    return

  $(document).on 'click', '#pgoods .btn_add', ->
    # g_id = $(this).attr('g_id')
    # if g_id != undefined
      # $('#attach_list').attr 'owner_cache', 
    $('#attach_list').attr 'owner_id', ''
    $('#attach_list').attr 'owner_type', 'ProjectGood'
    return

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

  return
