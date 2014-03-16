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
          $('#customer-information input[type="text"], #customer-information input[type="hidden"]').each ->
            input = $(this)
            setTimeout( ->
              input.val('')
            , 500
            )

  $("#customer-toggle label.btn:first").trigger 'click'


