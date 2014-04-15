$ ->
  set_bindings()



set_bindings = ->
  $('.remove-line-item').on 'click', ->
    id = $(this).siblings('.event_id').html()
    tr = $(this).closest('tr')
    row_count = tr.parents('table').find('tbody tr').length
    if row_count > 1
        remove_item(id, refresh)
    else
      if confirm('Removing the last line item will permanently delete the invoice
                  as well as any associated payment records!\n\n
                  Are you sure?')
        remove_item(id, return_to_property)

  $('.add-line-item').on 'click', ->
    event_id = $(this).siblings('.event_id').html()
    invoice_id = $('.invoice_id').html()
    add_item(event_id, invoice_id, refresh)

  $('#add_all').on 'click', ->
    add_all_items()

remove_item = (id, callback)->
  $.ajax({
    url:'/events_remove_from_invoice'
    data: {id:id}
    method: 'post'
    dataType: 'json'
    success: ->
      if(window.opener != null)
        try
          $('#workorder_invoice_link',window.opener.document)[0].click()
          window.opener.refresh([$('#profile',window.opener.document), $('#workorders',window.opener.document)], callback())
        catch e
          callback()
  })

add_item = (event_id, invoice_id, callback)->
  $.ajax({
    url:'/events_add_to_invoice'
    data: {id:event_id, invoice_id:invoice_id}
    method: 'post'
    dataType: 'json'
    cache:false
    success: ->
      if(window.opener != null)
        log($('#profile',window.opener.document))
        try
          $('#workorder_invoice_link',window.opener.document)[0].click()
          window.opener.refresh([$('#profile',window.opener.document), $('#workorders',window.opener.document)], callback())
        catch e
          callback()
  })

add_all_items = ->
  $.each($('.add-line-item'), ->
    $(this).click()
  )

refresh = ->
  $.ajax({
    cache:false
    url:window.location
    method:'get'
    dataType:'html'
    success: (data)->
      $('#past_events').html($($.parseHTML(data)).find('#past_events'))
      $('#invoice_document').html($($.parseHTML(data)).find('#invoice_document'))
      set_bindings()
  })

return_to_property = ->
  $.each [$('#profile',window.opener.document), $('#workorders',window.opener.document)], ->
    $(this).css('opacity', 1)
  window.close()