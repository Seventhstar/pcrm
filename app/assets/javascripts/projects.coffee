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

@changeProjectDays = () ->
  # if ptr.name == 'project[date_end_plan]' or ptr.name == 'project[date_start]'
    d1 = dateFromString($('#project_date_start').val())
    d2 = dateFromString($('#project_date_end_plan').val())
    # console.log('d1', d1, 'd2', d2)
    v  = $('#holidays').val().split(" ")
    w  = $('#workdays').val().split(" ")
    days = moment().isoWeekdayCalc(d1, d2, [1,2,3,4,5], v, w)
    # console.log('days', days)
    $('#project_days').val(days)
    return

@setDateEnd = (addDays) ->
    dateStart = dateFromString $('#project_date_start').val()
    v = $('#holidays').val().split(" ")
    w = $('#workdays').val().split(" ")
    # console.log('calcalting...', dateStart, addDays)
    d = moment(dateStart).isoAddWeekdaysFromSet
      'workdays': addDays
      'weekdays': [1,2,3,4,5]
      'exclusions': v
      'inclusions': w
    dd = $.datepicker.formatDate('dd.mm.yy', new Date(d))
    $('#project_date_end_plan').val dd
    return dd

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

  $('#project_payd_full, #project_payd_q').click ->
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

  # $('#project_days').on 'mousewheel', ->
    # stop: ( event, ui ) ->

      # console.log($(this).val())
             # alert($(this).attr('value'));
        

  $(document).on 'change', '#project_date_start', ->
    # console.log('project_date_start')
    footages.dateStart = $('#project_date_start').val()
    changeProjectDays()

  $(document).on 'change', '#project_date_end_plan', ->
    footages.dateEnd = $('#project_date_end_plan').val()
    changeProjectDays()


  $(document).on 'change', '#project_days', ->
    
    addDays  = $(this).val() - 1
    setDateEnd(addDays)
    # console.log(add)


  return
