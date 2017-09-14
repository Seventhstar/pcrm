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

  $(document).on 'click','.update', ->
    $('.close').click()
    delay('upd_ch_client({})',100)

  # $(document).ajaxSuccess (event, xhr, settings) ->
  #   alert(xhr.responseText)

  $(document).on 'ajax:success', 'form[data-modal]', (event, data, status, xhr)->
      url = xhr.getResponseHeader('Location')
      if url
        #alet(34)
        # Redirect to url
        window.location = url
      else
        # Remove old modal backdrop
        $('.close').click()
        $('.modal-backdrop').remove()

        # Replace old modal with new one
        $(modal_holder_selector).html(data).find(modal_selector).modal()
        apply_mask()
      false
