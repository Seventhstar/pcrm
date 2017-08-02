# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
 $(document).on 'change', '.goods_order_td .sw_enable', ->
  ch = $('#upd_modal_order').val()
  sum_supply = $('#upd_modal_sum_supply')
  if (ch=="true" && (sum_supply.val().length == 0 || sum_supply.val() == "0"))
  	sum_supply.val($('#upd_modal_gsum').val())
  return

