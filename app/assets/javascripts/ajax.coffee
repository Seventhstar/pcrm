# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# @showNotifications = ->
  
#   if $('.alert').hasClass('flash_success')
#     setTimeout (->
#      setTimeout '$(".alert").addClass("out")', 3000
#      return
#   ), 5000
#   return

@onBlur = (el)->
    if (el.value == '') 
        el.value = el.defaultValue;
    

@onFocus = (el)->
    if (el.value == '0' || el.value=='0,0' || el.value=='0.0' )
        el.value = '';

@store_cut = (param)->
  controller =  $('#search').attr('cname')
  $.ajax
      url: '/ajax/store_cut'
      data: {'cntr': controller, 'cut': param}
      type: 'POST'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
        return

@upd_param = (param, reload = false, modal = false)->
  $.ajax
      url: '/ajax/upd_param'
      data: param
      type: 'POST'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
        return
      success: (event, xhr, settings) ->
        disable_input(false)
        if reload then update_page()
        show_ajax_message(event,'success')
        if modal then $('.modal').modal('hide')
      error: (evt, xhr, status, error) ->      
        errors = evt.responseText
        show_ajax_message(errors,'error')
        showNotifications();  
     return

@update_page = ->
  $.get document.URL, null, null, 'script'

@disable_input_row = () ->
 $('.icon_hide_edit').each ->
  item_id = $(this).attr('item_id')
  $('#new_pgt_item'+item_id).hide()
  $('.new_row').hide()
  $('.btn_add').show()
  $('#pgt_item'+item_id).show()

@disable_input = (cancel=true) -> 
 item_id = $('.icon_apply').attr('item_id')
 item_rm_id = $('.icon_cancel').attr('item_id')
 $cells = $('.editable')
 $cells.each ->
  _cell = $(this)
  _cell.removeClass('editable')
  if cancel
    _cell.html _cell.attr('last_val')
  else
    _cell.html _cell.find('input').val()    
  return

 $cell = $('td.app_cancel')  
 $cell.removeClass('app_cancel')
 if item_rm_id == 'undefined' || item_rm_id == ''  
  del_span = '<span class="icon icon_remove_disabled"></span>' 
 else 
  del_span = '<span class="icon icon_remove" item_id="'+item_id+'"></span>'
 $cell.html ('<span class="icon icon_edit" item_id="'+item_id+'"></span>'+del_span)

@apply_opt_change = (item)->
  model = item.closest('table').attr('model')
  item_id = item.attr('item_id')
  upd_pref = 'upd'+item_id
  inputs = $('input[name^='+upd_pref+']').serialize()
  if inputs.length == 0
    upd_pref = 'upd'
    inputs = $('input[name^=upd]').serialize()
  sel = $('select[name^='+upd_pref+']').serialize()
  inputs = inputs + "&"+sel if sel.length>0
  upd_param(inputs+'&model='+model+'&id='+item_id,true)  
  if item.closest('td').hasClass('l_edit') then sortable_query({})
  return

@cell_to_edit = (cl)->
  cl.addClass('editable')
  table = cl.closest('table')
  val = cl.html()      
  cl.data('text', val).html ''
  cl.attr('last_val',val)  
  fld = table.find('th:eq('+cl.index()+')').attr('fld')
  cl.attr('ind', fld)
  type = cl.attr('type')
  type = if type == undefined then 'text' else type      
  $input = $('<input type="'+type+'" name=upd['+fld+'] />').val(cl.data('text')).width(cl.width() )
  cl.append $input
  cl.context.firstChild.focus()

@sort_base_url = ->
  method = if $('#cur_method').val() == 'edit_multiple' then '/edit_multiple' else ''
  controller =  $('#search').attr('cname')
  return controller+method

@sortable_prepare = (params)->
  actual = if $('.only_actual').length==0 then null else $('.only_actual').hasClass('on')

  url = {    
    only_actual: actual
    sort: $('span.active').attr('sort')
    direction: $('span.active').attr('direction')
    sort2: $('span.subsort.current').attr('sort2')
    dir2: $('span.subsort.current').attr('dir2')
    search: $('#search').val()
    year: $('#year').val()
    currency: $('#currency_id').val()
    good_state: $('#good_state').val()
  }
  
  l = window.location.toString().split('?');
  p = q2ajx(l[1])
  ser = $('.index_filter').serialize()
  if ser == ""
    ser = $('.index_filter select').serialize()
  p_params = q2ajx(ser)
  

  each p, (i, a) ->
    if ['search','page','_'].include? i 
      url[i] = a
    return
  each p_params, (i, a) ->
    url[i] = a
    return
  each params, (i, a) ->
    url[i] = a
    return 

  return url

@sortable_query = (params)->
  url = sortable_prepare(params)
  base_url = sort_base_url()

  $.get '/'+base_url, url, null, 'script'
  setLoc(""+base_url+"?"+ajx2q(url));
  return

@apply_mask = ->
  $('.sum_mask').mask '# ##0',
    reverse: true
    maxlength: false
  $('.chosen').chosen(width: '99.5%', disable_search: 'true')
  $('.schosen').chosen(width: '99.5%')
  $('.tab-chosen').chosen(width: '150px').on 'change', ->
    l = $('form').attr('action');
    p = $(".ui-tabs-active a").attr('href')
    par ='good_state='+$('#good_state').val()
    url = l+"/edit"+p
    $.get url, par, null,'script'
    setLoc(l.substring(1)+"/edit"+"?"+par+p)
    return
  # меняем ширину progress`бара
  $('.bar').each ->
    w = $(this).attr('w')
    if w == "" then w = 100
    $(this).width(w+'%')
    col = $(this).attr('c')
    if col == undefined then col = 'c7c7c7'
    col = '#'+col
    $(this).css("backgroundColor", col) 
  # подкрашиваем остатки из-за rowspan
  $("tr").hover (->
    ri = $(this).attr('tr_id')
    $('.tr_id'+ri).addClass('hover')
  ), ->
    ri = $(this).attr('tr_id')
    $('.tr_id'+ri).removeClass('hover')

$(document).ready ->
  apply_mask()

  $(document).on 'click', '.close', ->
      $(this).closest('.alert').removeClass("in").addClass('out');

  $(document).on 'click', 'span.modal_apply', ->
    prm = $(this).attr('prm')
    model = $(this).attr('model')
    item_id = $(this).attr('item_id')
    params = $('[name^='+prm+']').serialize()    
    upd_param(params+'&model='+model+'&id='+item_id,true,true)

# поиск 
  $('#search').on 'keyup', (e)-> 
    c= String.fromCharCode(event.keyCode);
    isWordCharacter = c.match(/\w/);
    isBackspaceOrDelete = (event.keyCode == 8 || event.keyCode == 46);
    if (isWordCharacter || isBackspaceOrDelete)
       delay('sortable_query({})',700)
    return
# обновление данных в таблицах страниц index
  $('.index_filter select,.index_filter input[type="radio"]').on 'change', ->
    sortable_query({})
    return

  $('.schosen').chosen(width: '99.5%')
  $('.chosen').chosen(width: '99.5%', disable_search: 'true')

  $('.ychosen').chosen(width:' 78px', disable_search: 'true', inherit_select_classes: 'true').on 'change', ->
    sortable_query({})
    return



  $('.srtchosen').chosen(width:'165px', disable_search: 'true').on 'change', ->
    sortable_query({})
    return


# редактирование ячейки в таблице
  $('.container').on 'dblclick', 'td.l_edit', ->  
      if $(this).hasClass('editable')  then return      
      disable_input()
      cell_to_edit($(this))      
      return

# редактирование данных в таблице
  $('.container').on 'click', 'span.icon_edit', ->
    item_id = $(this).attr('item_id')
    item_rm_id= $(this).next().attr('item_id')
    $row = $(this).parents('')
    disable_input()
    $cells = $row.children('td').not('.edit_delete,.state')    
    $cells.each ->
      cell_to_edit($(this))
      return

    $cell = $row.children('td.edit_delete')  
    $cell.addClass('app_cancel')
    $cell.html '<span class="icon icon_apply" item_id="'+item_id+'"></span><span class="icon icon_cancel" item_id="'+item_rm_id+'"></span>'
    
   # отмена редактирования
   $('.container').on 'click', 'span.icon_cancel', ->   
     disable_input()
     return

   $('.container').on 'click', 'span.icon_hide_edit', ->   
     disable_input_row()
     return

   # отправка новых данных
   $('.container').on 'click', 'span.icon_apply', -> 
    apply_opt_change($(this))

 
   $('body').on 'keyup', '.editable input', (e) ->
      if e.keyCode == 13
        if $(this).offsetParent().hasClass('chosen-search')
          return  
        else if $(this).closest('table').attr('model')=='ProjectGood'
          $(this).closest('td').siblings().last().children('#btn-sub-send').click()
          e.preventDefault()
        else if $(this).closest('td').hasClass('l_edit') 
          i = $('.l_edit.editable')
        else if $(this).closest('tr').hasClass('editable')
          i = $(this).closest('td').siblings().last().children('.icon_apply')
        else 
          i = $('span.icon_apply')
        if (i!=undefined)
          apply_opt_change(i)
      else if e.keyCode == 27 
        disable_input()
      return
   $('body').on 'keyup keypress','.edit_project input', (e)->
      if e.keyCode == 13 || e.keyCode == 8
        e.preventDefault()
      return 
   $('body').on 'keyup keypress', '.simple_options_form',(e) ->
    code = e.keyCode or e.which
    if code == 13
      e.preventDefault()
      if e.type == 'keyup'
        $('#btn-send').trigger('click');
        return
      return false
    return
    
  $(document).on 'click', '.cut', ->
    $(this).toggleClass('cutted')
    id = 'table' + $(this).attr('cut_id')
    $('#'+id).slideToggle( "slow" )
    url = sortable_prepare({})
    base_url = sort_base_url()
    cut = ""
    $('.cutted').each ->
      cut = cut+$(this).attr('cut_id')+'.'
    
    url['cut'] = cut if cut!=''
    store_cut(ajx2q(url))
    setLoc(""+base_url+"?"+ajx2q(url));

  $("#back-top").hide();

$ ->
  $(window).scroll ->
    dh = $(document).height()
    st = $(this).scrollTop()
    if st > 150
      $('#back-top').fadeIn()
    else
      $('#back-top').fadeOut()
    if st > 250 
      $('#to_bottom').fadeOut()
    else if dh>1200
      $('#to_bottom').fadeIn()

  # при клике на ссылку плавно поднимаемся вверх
  $('#back-top a').click ->
    $('body,html').animate { scrollTop: 0 }, 500
    false
  $('#to_bottom a').click ->
    $('body,html').animate { scrollTop:($(document).height()-1050) }, 500
    false 