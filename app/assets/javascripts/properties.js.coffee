$ ->

  options = $.extend(datatable_defaults(), "sAjaxSource": "/properties_data_tables_source")
  $('#properties.datatable').dataTable(options);

  $('.datatable th').addClass('h4')

  #toggle show/hide for new or existing customer based on toggle selection
  $("#customer-toggle label.btn").on "click", ->
    selected = $(this).children("input[type=\"radio\"]").attr("id")
    display_element = $("div[class~='" + selected + "']")
    $("#customer-information .toggle-group:not([class~='" + selected + "'])").fadeOut
      complete: ->
        display_element.delay(600).fadeIn()
        display_element.find("input:first").focus()
        if selected is "existing-customer" or selected is "current-customer"
          initialize_search "customer-search"
          $('.new-customer input').each ->
            input = $(this)
            setTimeout( ->
              input.val('')
            , 500
            )

  $("#customer-toggle label.btn:first").trigger 'click'

  $(document).on 'ajax:complete', ->
    $('.datatable').dataTable().fnReloadAjax();

  $('form[data-remote=true]').on 'ajax:success', (event, jqXHR, ajaxSettings)->
    msg = parse_json_message(jqXHR)
    notify('success', msg)
    form = $(this)
    form.find('input[type="text"]').each ->
      $(this).val('').css({border: 'none'})

  $('form[data-remote=true]').on 'ajax:complete', ->
    $('#ajax-modal').modal('hide')
    refresh_profile()

  $('form[data-remote=true]').on 'ajax:error', (event, jqXHR, ajaxSettings, thrownError)->
    try
      msg = parse_json_errors(jqXHR)
    catch
      msg = 'Something weird is going on. Might want to call whoever is supporting this thing...'

    notify('error', msg)
    fields = $(get_error_fields(jqXHR))
    fields.each ->
      field = $(this).find('input')
      field.css({'border-radius': '5px', 'border': '1px solid red'})


  refresh_profile = ->
    $.ajax({
      global: false
      url:'/refresh_profile'
      dataType: 'html'
      data: {id: $('#id').html()}
      error: (jqXHR, textStatus, errorThrown )->
        alert(textStatus)
      success: (data, textStatus, jqXHR)->
        console.log(data)
        $('#profile').html(data)
    })

