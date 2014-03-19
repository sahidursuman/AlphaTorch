adjustMapHeight = ->
  $('#map-canvas').css('height', $('#property-form').height())

$ ->
  adjustMapHeight()
  ajax_loader($('#map-canvas'),fetch_map_data)

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
              input.val('') unless input.is('[readonly="readonly"]')
            , 500
            )

  $("#customer-toggle label.btn:first").trigger 'click'

  $('.workorder').on 'click', ->
    url = $(this).data('url')
    $('#workorder-data').load(url)
    $('#workorder-data').attr('data-url', url)

  $('#new_property').on 'ajax:success', ->
    ajax_loader($('#map-canvas'),fetch_map_data)

  $(window).on 'resize', ->
    adjustMapHeight()


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
