$ ->

  options = $.extend(datatable_defaults(),
    "sAjaxSource": "/customers_data_tables_source",
    "aaSorting": [[5, "asc"]]
  )
  $('#customers.datatable').dataTable(options);

  $('.datatable th').addClass('h4')

  #toggle show/hide for new or existing property based on toggle selection
  $("#property-toggle label.btn").on "click", ->
    selected = $(this).children("input[type='radio']").attr("id")
    display_element = $("div[class~='" + selected + "']")
    $("#property-information .toggle-group:not([class~='" + selected + "'])").fadeOut
      complete: ->
        display_element.delay(600).fadeIn()
        display_element.find("input:first").focus()
        if selected is "existing-property" or selected is "current-property"
          initialize_search "property-search"
          $('.new-property input, .existing-property input').each ->
            input = $(this)
            setTimeout( ->
              input.val('')
            , 500
            )
  $("#property-toggle label.btn:first").trigger 'click'

  $('.property').on 'click', ->
    url = $(this).data('url')
    $('#property-data').load(url)
    log(url)
    $('#property-data').attr('data-url', url)


  # Validate form dynamically as user inputs information before submitting
  $ ->
    if $("#new_customer, #edit_customer").length
      $("#new_customer, #edit_customer").validate
        rules:
          'customer[first_name]':
            required: true
            minlength: 2

          'customer[last_name]':
            required: true
            minlength: 2

          'customer[email]':
            required: false
            email: true

          'customer[primary_phone]':
            required: true

        messages:
          'customer[first_name]':
            required: "* Enter customer's first name"
            minlength: "* {0} characters required"

          'customer[last_name]':
            required: "* Enter customer's last name"
            minlength: "* {0} characters required"

          'customer[email]':
            minlength: "* Please enter a valid email address"

          'customer[primary_phone]':
            required: "* Phone required"

        errorPlacement: (error, element) ->
          if element.parent().is(".input-append")
            error.appendTo element.parents(".controls:first")
          else
            error.insertAfter element