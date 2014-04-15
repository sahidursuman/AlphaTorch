$ ->
  initialize_search('invoice-search')

  $("#payment-toggle label.btn").on "click", ->
    selected = $(this).children("input[type=\"radio\"]").attr("id")
    display_element = $("div[class~='" + selected + "']")
    $(".toggle-group:not([class~='" + selected + "'])").fadeOut
      complete: ->
        display_element.delay(600).fadeIn()
        display_element.find("input:first").focus()
        setTimeout(->
          $('#payment-information input[type="text"]').each(->
            $(this).val('')
          )
        , 300
        )

  unless $('form[id*="edit"]').length
    $("#payment-toggle label.btn:first").trigger 'click'
  else
    method = $('#method').val().toLowerCase()
    toggle_button = $('label.btn input[id*="'+method+'"]').parent('label')
    log(toggle_button)
    toggle_button.addClass('active')
    toggle_group = $('.toggle-group[class*="'+method+'"]')
    hidden_groups = ($('.toggle-group:not([class*="'+method+'"])'))
    toggle_group.css('display', '')
    $.each hidden_groups, ->
      $(this).css('display', 'none')