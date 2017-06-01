@upd_ch_client =() ->
  $.ajax 'update_',
      type: 'GET'
      dataType: 'script'
      data: {
        client_id: $("#project_client_id option:selected").val()
      }


$ ->
  modal_holder_selector = '#modal-holder'
  modal_selector = '.modal'

  $(document).on 'click', '.cut', ->
    $(this).toggleClass('cutted')
    id = 'table' + $(this).attr('cut_id')
    $('#'+id).slideToggle( "slow" )

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
    return

  # при клике на ссылку плавно поднимаемся вверх
  $('#back-top a').click ->
    $('body,html').animate { scrollTop: 0 }, 500
    false
  $('#to_bottom a').click ->
    $('body,html').animate { scrollTop:($(document).height()-1050) }, 500
    false
  return

  $(document).on 'click', 'a[data-modal]', ->
    location = $(this).attr('href')
    #Load modal dialog from server
    $.get location, (data)->
      $(modal_holder_selector).html(data).find(modal_selector).modal()
    false

  $(document).on 'click','.update', ->
    $('.close').click()
    delay('upd_ch_client({})',100)

  # $(document).on 'click','.test_cl', ->
    # delay('upd_ch_client({})',70)

  $(document).on 'ajax:success', 'form[data-modal]', (event, data, status, xhr)->
      url = xhr.getResponseHeader('Location')
      if url
        # Redirect to url
        window.location = url
      else
        # Remove old modal backdrop
        $('.modal-backdrop').remove()

        # Replace old modal with new one
        $(modal_holder_selector).html(data).
        find(modal_selector).modal()
      false
