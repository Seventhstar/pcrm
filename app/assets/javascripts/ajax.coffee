# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@upd_param = (param)->
  $.ajax
      url: '/ajax/upd_param'
      data: param
      type: 'POST'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
        return
      success: ->
        disable_input(false)
        show_ajax_message('Успешно обновлено')
     return


@disable_input = (cancel=true) -> 
 item_id = $('.icon_apply').attr('item_id')
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
 $cell.html '<span class="icon icon_edit" item_id="'+item_id+'"></span><span class="icon icon_remove" item_id="'+item_id+'"></span>' 

@apply_opt_change = (item)->
  model = item.closest('table').attr('model')
  item_id = item.attr('item_id')
  inputs = $('input[name^=upd]')
  upd_param(inputs.serialize()+'&model='+model+'&id='+item_id)  

$(document).ready ->
  $('.schosen').chosen(width: '99.5%')
  $('.chosen').chosen(width: '99.5%', disable_search: 'true')
# редактирование данных в таблице
  $('.container').on 'click', 'span.icon_edit', ->
    item_id = $(this).attr('item_id')
    $row = $(this).parents('')
    disable_input()
    $cells = $row.children('td').not('.edit_delete,.state')
    table = $(this).closest('table')
    $cells.each ->
      _cell = $(this)
      _cell.addClass('editable')
      val = _cell.html()      
      _cell.data('text', val).html ''
      _cell.attr('last_val',val)
      _cell.attr('ind', table.find('th:eq('+_cell.index()+')').attr('fld'))
      type = _cell.attr('type')
      type = if type == undefined then 'text' else type      
      $input = $('<input type="'+type+'" name=upd['+table.find('th:eq('+_cell.index()+')').attr('fld')+'] />').val(_cell.data('text')).width(_cell.width() - 16)
      _cell.append $input
      return

    $cell = $row.children('td.edit_delete')  
    $cell.addClass('app_cancel')
    $cell.html '<span class="icon icon_apply" item_id="'+item_id+'"></span><span class="icon icon_cancel" item_id="'+item_id+'"></span>'
    
   # отмена редактирования
   $('.container').on 'click', 'span.icon_cancel', ->   
     disable_input()

   # отправка новых данных
   $('.container').on 'click', 'span.icon_apply', ->  
    apply_opt_change($(this))
 
   $('body').on 'keyup', '.editable input', (e) ->
      if e.keyCode == 13
        apply_opt_change($('span.icon_apply'))
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
    