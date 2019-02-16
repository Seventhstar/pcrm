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

  $(document).on 'click', 'a[data-modal]', ->
    location = $(this).attr('href')
    #Load modal dialog from server
    $.get location, (data)->
      $(modal_holder_selector).html(data).find(modal_selector).modal()
    false

  $('body').on 'click', '.autoresize', ->
    ael = document.activeElement
    ael.height = 'auto';
    ael.style.height = ael.scrollHeight+'px';

  $('body').on 'keypress keyup', '#mainModal', (e)->
    if e.keyCode == 13
      ael = document.activeElement
      if ael.type == 'textarea'
        ael.height = 'auto';
        ael.style.height = ael.scrollHeight+'px';
      else
        $('#btn-modal').click()
    else if e.keyCode == 27
      $('.close').click()

  $(document).on 'click','.update', ->
    $('.close').click()
    delay('upd_ch_client({})',100)

  $(document).on 'ajax:success', 'form[data-modal]', (event, data, status, xhr)->
      url = xhr.getResponseHeader('Location')
      if url
        window.location = url
      else
        # Remove old modal backdrop
        $('.close').click()
        $('.modal-backdrop').remove()

        # Replace old modal with new one
        $(modal_holder_selector).html(data).find(modal_selector).modal()
        apply_mask()
      false
