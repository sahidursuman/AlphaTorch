adjustDivHeight = ->
  $('#map-canvas').css('height', $('#property-form').height())
  $('#workorders').css('height', $('#profile').height())
$ ->
  adjustDivHeight()
  if $('#map-canvas').length
    ajax_loader($('#map-canvas'),fetch_map_data)

  options = $.extend(datatable_defaults(),
    "sAjaxSource": "/properties_data_tables_source",
    "aaSorting": [[3, "desc"]]
  )
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
              input.val('') unless input.is('[readonly="readonly"]')
            , 500
            )

  $("#customer-toggle label.btn:first").trigger 'click'

  $('.workorder').on 'click', ->
    url = $(this).data('url')
    $('#workorder-data').load(url)
    $('#workorder-data').attr('data-url', url)

  $('#new_property').on 'ajax:success', ->
    ajax_loader($('#map-canvas'), fetch_map_data)


  $(window).on 'resize', ->
    adjustDivHeight()


fetch_map_data = ->
  $.ajax({
    cache: false
    global: false
    method: 'get'
    url: '/properties_load_property_map_data'
    success: (data)->
      new HeatMap(data)
    complete: ->
      clear_ajax_loader()

  })


  # Validate form dynamically as user inputs information before submitting
  $ ->
    if $("#new_property, #edit_property")
      $("#new_property, #edit_property").validate
        rules:
          'property[first_name]':
            required: true
            minlength: 2

          'property[last_name]':
            required: true
            minlength: 2

          'property[email]':
            required: false
            email: true

          'property[primary_phone]':
            required: true

        messages:
          'property[first_name]':
            required: "* Enter customer's first name"
            minlength: "* {0} characters required"

          'property[last_name]':
            required: "* Enter customer's last name"
            minlength: "* {0} characters required"

          'property[email]':
            minlength: "* Please enter a valid email address"

          'property[primary_phone]':
            required: "* Phone required"

        errorPlacement: (error, element) ->
          if element.parent().is(".input-append")
            error.appendTo element.parents(".controls:first")
          else
            error.insertAfter element