$ ->

  options = $.extend(datatable_defaults(), "sAjaxSource": "/customers_data_tables_source")
  $('#customers.datatable').dataTable(options);

  $('.datatable th').addClass('h4')

  #toggle show/hide for new or existing property based on toggle selection
  $("#property-toggle label.btn").on "click", ->
    selected = $(this).children("input[type=\"radio\"]").attr("id")
    display_element = $("div[class~='" + selected + "']")
    $("#property-information .toggle-group:not([class~='" + selected + "'])").fadeOut
      complete: ->
        display_element.delay(600).fadeIn()
        display_element.find("input:first").focus()
        if selected is "existing-property" or selected is "current-property"
          initialize_search "property-search"
          $('.new-property input').each ->
            input = $(this)
            setTimeout( ->
              input.val('')
            , 500
            )

  $('.property').on 'click', ->
    url = $(this).data('url')
    $('#property-details').load(url)
    log(url)
    $('#property-details').attr('data-url', url)