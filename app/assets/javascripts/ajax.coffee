# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
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

@update_chosen = (id, list, nil_value)->
  need_update = ($(id + " option").toArray().length != (list.length+1))
  if need_update
    $(id).empty()
    newOption = $('<option value="0">'+nil_value+'</option>')
    $(id).append(newOption)
    list.forEach (e) ->
      newOption = $('<option value="'+e.id+'">'+e.name+'</option>')
      $(id).append(newOption)
    $(id).trigger("chosen:updated")

@upd_param = (param, reload = false, modal = false)->
  $.ajax
      url: '/ajax/upd_param'
      data: param
      dataType: 'json'
      type: 'POST'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
        return
      success: (event, xhr, settings) ->
        disable_input(false)
        # if reload then update_page()
        show_ajax_message(event, 'success')
        if modal then $('.modal').modal('hide')
      error: (evt, xhr, status, error) ->      
        show_ajax_message("Ошибка обновления (ajax): " + evt.responseText, 'error')
        showNotifications();  
     return

@update_page = ->
  $.get document.URL, null, null, 'script'

@paginate = (v)->
  $.get document.URL + '&page='+v, null, null, 'script'

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
  cls  = if cl.hasClass('option_day') then 'datepicker' else '' 
  $input = $('<input type="'+type+'" class="'+cls+'"  name=upd['+fld+'] />').val(cl.data('text')).width(cl.width() )
  cl.append $input
  cl.context.firstChild.focus()

@sort_base_url = ->
  method = if $('#cur_method').val() == 'edit_multiple' then '/edit_multiple' else ''
  controller =  $('#search').attr('cname')
  controller = controller + "/" + $('#search').attr('mname') if controller == 'options'
  if controller == undefined 
    controller = window.location.toString().split('?')[0].split('/').splice(3).join('/')
  return controller+method

@sortable_prepare = (params, getFromUrl = false, applink = undefined) ->
  app = applink

  actual = if $('.switcher_a .link_a').length == 0 then null else $('.switcher_a .link_a').hasClass('on')

  cut = ''
  cut_selecter = '.cut.cutted'
  if $('.goods_list').length>0
    cut_selecter = '.cut:not(".cutted")'
  
  $(cut_selecter).each ->
    cut = cut + $(this).attr('cut_id') + '.'

  search = $('#search').val()
  year = if (nav? && nav.year?) then nav.year.value else $('#year').val()
  # console.log('nav', nav, 'nav.year', nav.year, year)

  $('.search_save a').each (i) ->
    href = new URL(this.href)
    if search == '' || search == undefined
      href.searchParams.delete('search')
    else 
      href.searchParams.set('search', search)
    this.href = href

  url = {    
    only_actual: actual
    sort: $('span.active').attr('sort')
    direction: $('span.active').attr('direction')
    sort2: $('span.subsort.current').attr('sort2')
    dir2: $('span.subsort.current').attr('dir2')
    search: search
    year: year
    priority_id: $('#priority_id').val()
    good_state: $('#good_state').val()
    cut: cut
  }

  l = window.location.toString().split('?')
  p = q2ajx(l[1])
  ser = $('.index_filter').serialize()
  if ser == ""
    ser = $('.index_filter select').serialize()
  if_params = q2ajx(ser)
  
  each p, (i, a) -> # restore params from url
    if url[i] == undefined || ['search','page','_'].include? i 
      url[i] = a
    return

          # url.remove(e.name)
        # else

  each if_params, (i, a) -> # add params from .index_filter
    url[i] = a
    return

  each params, (i, a) -> # add params from args hash
    url[i] = a
    return 

  if (app?)
    filtersList = app.getFiltersList()
    if filtersList != undefined
      filtersList.forEach (e) ->
        if e.value != undefined 
          # url[e.name] = app[e.name].value
          url[e.name] = e.value
          # console.log('sortable_prepare 1', e.name, e.value, app[e.name].value )
        else if app.readyToChange == undefined || app.readyToChange
          # console.log('sortable_prepare 2', e.name, e.value, e )
          delete url[e.name]
        return
 

  each url, (i, a) ->
    if (a == 0 || a == '0' || a == undefined)
      delete url[i]  
    return 
    
  base_url = sort_base_url()  
  setLoc(""+base_url+"?"+ajx2q(url));
  return url

@filterToHistory = (params)->
  url = sortable_prepare(params, true)
  base_url = sort_base_url()
  setLoc("" + base_url + "?" + ajx2q(url));
  return

@sortable_vue = (params) ->
  s = $('#search').val()
  app.onInput({name: 'search', label: s, value: s}); 

@sortable_query = (params) ->
  url = sortable_prepare(params)
  base_url = sort_base_url()

  if (!app?)
    $.get '/'+base_url, url, null, 'script'
  else if (app.useSearchVue == undefined)
    $.get '/'+base_url, url, null, 'script'
  else
    sortable_vue()

  # setLoc(""+base_url+"?"+ajx2q(url));
  return

@apply_mask = ->
  mask = 
    groupSeparator: ' '
    alias: 'numeric'
    placeholder: '0'
    autoGroup: !0
    digits: 2
    digitsOptional: !1
    clearMaskOnLostFocus: !1
  $('.float_mask').inputmask mask
  $('.footage_mask').inputmask mask
  mask.digits = 0 
  $('.sum_mask').inputmask mask
  $('.discount_mask').inputmask mask

  $('#tabs_msg').tabs activate: (event, ui) ->
    color = undefined
    if $('#tab_special_info').closest('li').hasClass('ui-tabs-active')
      color = 'red'
    else
      color = '#6acc00'
    $('.comments_box .box_msg ul.ui-tabs-nav').css 'border-bottom', color + ' 2px solid'
    return

  $('.chosen').chosen(width: '99.5%', disable_search: 'true')
  $('.multi-select').chosen(width: '99.5%', disable_search: 'true')
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
    if col.charAt(0) != '#' then col = '#'+col 
    $(this).css("backgroundColor", col) 
  # подкрашиваем остатки из-за rowspan
  $("tr").hover (->
    ri = $(this).attr('tr_id')
    $('.tr_id'+ri).addClass('hover')
  ), ->
    ri = $(this).attr('tr_id')
    $('.tr_id'+ri).removeClass('hover')

@modal_apply = (th, newItem=false)->
  prm = th.attr('prm')
  action = th.attr('action')
  item_id = th.attr('item_id')
  model = th.attr('model')
  params = $('[name^='+prm+']').serialize()    
  # console.log()
  if th.hasClass('new') || newItem 
    type = 'POST' 
    url  = action
  else 
    type = 'PATCH'
    url  = action+item_id

  # upd_param(params+'&model='+model+'&id='+item_id,true,true)
  $.ajax
    url: url
    data: params
    dataType: 'script'
    type: type
    success: (event, xhr, settings) ->
      if event.includes('.js-notes')
        eval(event)
      else
        show_ajax_message('Успешно обновлено','success')
    error: (evt, xhr, status, error) ->  
      show_ajax_message("Ошибка обновления: " + status.message,'error')        
                                             
$(document).ready ->
  apply_mask()

  $(document).on 'click', '.close', ->
      $(this).closest('.alert').removeClass("in").addClass('out');

  $(document).off('click', 'span.modal_apply').on 'click', 'span.modal_apply', ->
    modal_apply($(this))
    # console.log('modal apply')

# поиск 
  $('#search').on 'keyup clear', (e)-> 
    c = String.fromCharCode(e.keyCode);
    isWordCharacter = c.match(/\w/);
    isBackspaceOrDelete = (e.keyCode == 8 || e.keyCode == 46 || e.keyCode == 13 || e.type == 'clear');
    if (isWordCharacter || isBackspaceOrDelete)
      delay('sortable_query({})',700)
    return
# обновление данных в таблицах страниц index
  $('.index_filter select,.index_filter input[type="radio"]').on 'change', ->
    sortable_query({})
    return

  $('.schosen').chosen(width: '99.5%')
  $('.chosen').chosen(width: '99.5%', disable_search: 'true')
  # $('select').chosen(width: '99.5%', disable_search: 'true')


  $('.ychosen').chosen(width:' 78px', disable_search: 'true', inherit_select_classes: 'true').on 'change', ->
    sortable_query({})
    return
  $('.pchosen').chosen(width:' 108px', disable_search: 'true', inherit_select_classes: 'true').on 'change', ->
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

  $('body').on 'keyup', (e) ->
    if $('.auth_form').length > 0 && e.ctrlKey && e.keyCode == 13
      $('#login_submit').click()
    return
    
  # отправка новых данных
  $('.container').on 'click', 'span.icon_apply', -> 
    apply_opt_change($(this))
    return

  $('body').on 'keyup', '.search-field input', (e) ->
    if e.keyCode == 13
      $('.chcreate').trigger('mousedown')
    return

  $('body').on 'keyup', '#new_item input', (e)->
    if e.keyCode == 13
      $('#btn-sub-send').trigger('click')
    return
 
  $('body').on 'keyup', '.editable input', (e) ->
    if e.keyCode == 13
      if $(this).offsetParent().hasClass('chosen-search')
        return  
      else if $(this).closest('table').attr('model')=='ProjectGood'
        $(this).closest('td').siblings().last().children('#btn-sub-send').click()
        e.preventDefault()
      else if $(this).closest('td').hasClass('l_edit') 
        i = $('.l_edit.editable')
      else if $(this).closest('td').hasClass('editable')
        i = $(this).closest('td').siblings().last().children('.icon_apply')
      else if $(this).closest('grid_table_goods') != undefined
      else 
        i = $('span.icon_apply')
      if (i!=undefined)
        apply_opt_change(i)
    else if e.keyCode == 27 
      disable_input()
    return

  $('body').on 'keyup keypress', '.edit_project input', (e)->
    if e.keyCode == 13 || e.keyCode == 8
      e.preventDefault()
    return 
  
  $('body').on 'keyup keydown', '.simple_options_form', (e) ->
    code = e.keyCode or e.which
    if code == 13
      e.preventDefault()
      if e.type == 'keyup'
        $('#btn-send').trigger('click');
        return
      return false
    return

  $(document).on 'click', '.altcut', ->
    $(this).toggleClass('cutted')
    id = 'table_' + $(this).attr('cut_id')
  
  $(document).on 'click', '.allcut', ->
    $(this).toggleClass('cutted')
    id = 'table_' + $(this).attr('cut_id')

  $(document).on 'click', '.cut', ->
    $(this).toggleClass('cutted')
    id = 'table_' + $(this).attr('cut_id')
    $('#'+id).slideToggle( "slow" )
    url = sortable_prepare({})
    base_url = sort_base_url()
    cut = ""

    cut_selecter = '.cutted'
    if $('.goods_list').length>0
      cut_selecter = '.cut:not(".cutted")'
    
    $(cut_selecter).each ->
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

    v = parseInt $('#page_num').val()
    if($(window).scrollTop() == dh - $(window).height()) && v > 0
      $("#page_"+v).html("Загружается...")
      delay('paginate('+v+')',100)
    

  # при клике на ссылку плавно поднимаемся вверх
  $('#back-top a').click ->
    $('body,html').animate { scrollTop: 0 }, 500
    false
  $('#to_bottom a').click ->
    $('body,html').animate { scrollTop:($(document).height()-1050) }, 500
    false 