# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@addParam = (url, param, value) ->
  a = document.createElement('a')
  regex = /[?&]([^=]+)=([^&]*)/g
  match = undefined
  str = []
  a.href = url
  value = value or ''
  while match = regex.exec(a.search)
    if encodeURIComponent(param) != match[1]
      str.push match[1] + '=' + match[2]
  str.push encodeURIComponent(param) + '=' + encodeURIComponent(value)
  a.search = (if a.search.substring(0, 1) == '?' then '' else '?') + str.join('&')
  a.href

$(document).ready ->

  $('#lead_channel_id').chosen(width: '99.5%', disable_search: 'true')
  $('#lead_status_id').chosen(width: '99.5%', disable_search: 'true')
  $('.inp_w #lead_user_id').chosen(width: '99.5%', disable_search: 'true')
  $('.inp_w #lead_ic_user_id').chosen(width: '99.5%', disable_search: 'true')
  $('#user_id').chosen(width: '200px', disable_search: 'true')

  # основновная сортировка
  $('.container').on 'click', 'span.sort-span', ->
    #alert(12)
    srt = $(this).attr('sort')
    dir = $(this).attr('direction')

    if $(this).hasClass('active')
      dir = if dir == 'asc' then 'desc' else 'asc'
      $(this).attr('direction',dir)
    else
      $('.sort-span').removeClass('active')
      $(this).addClass('active')
    sortable_query({sort: srt,direction:dir})
    return

  # сортировка 2го уровня
  $('.container').on 'click', 'span.subsort', ->
    dir2 = $(this).attr('dir2')
    srt2 = $(this).attr('sort2')
    if $(this).hasClass('current')
      dir2 = if dir2 == 'asc' then 'desc' else 'asc'
    sortable_query({sort2:srt2,dir2:dir2})
    return

  return