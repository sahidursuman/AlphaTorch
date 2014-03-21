$ ->
  initialize_search('invoice-search')

  $("#payment-toggle label.btn").on "click", ->
    selected = $(this).children("input[type=\"radio\"]").attr("id")
    display_element = $("div[class~='" + selected + "']")
    $(".toggle-group:not([class~='" + selected + "'])").fadeOut
      complete: ->
        display_element.delay(600).fadeIn()
        display_element.find("input:first").focus()

  $("#payment-toggle label.btn:first").trigger 'click'