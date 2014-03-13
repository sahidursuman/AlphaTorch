$ ->

  options = $.extend(datatable_defaults(), "sAjaxSource": "/properties_data_tables_source")
  $('#properties.datatable').dataTable(options);

  options = $.extend(datatable_defaults(), "sAjaxSource": "/workorder_data_tables_source")
  $('#workorders.datatable').dataTable(options);

  $('.editable').editable();

  #toggle show/hide for new or existing customer based on toggle selection
  $("#customer-toggle label.btn").on "click", ->
    selected = $(this).children("input[type=\"radio\"]").attr("id")
    display_element = $("div[class~='" + selected + "']")
    $("#customer-information .toggle-group:not([class~='" + selected + "'])").fadeOut
      complete: ->
        display_element.fadeIn()
        display_element.find("input:first").focus()
        if selected is "existing-customer"
          initialize_search "customer-search"
          $('.new-customer input').each ->
            $(this).val('')
        else
          $('.existing-customer input').each ->
            $(this).val('')

  $('form[data-remote=true]').on 'ajax:success', (event, jqXHR, ajaxOptions)->
    notify('success', 'Property was successfully added!')
    form = $(this)
    form.find('input[type="text"]').each ->
      $(this).val('').css({border: 'none'})
    $('.datatable').dataTable().fnAddData(getPropertyData(jqXHR), true)

  $('form[data-remote=true]').on 'ajax:error', (event, jqXHR, ajaxSettings, thrownError)->
    console.log("ERROR #{event.target}")
    console.log(jqXHR)
    msg = parse_json_errors(jqXHR)
    fields = $(get_error_fields(jqXHR))
    notify('error', 'Oops! There was an error processing your request! <br/>' + msg)
    fields.each ->
      field = $(this).find('input')
      field.css({'border-radius': '5px', 'border': '1px solid red'})

  getPropertyData = (jqXHR)->
    console.log($.parseJSON(jqXHR))


