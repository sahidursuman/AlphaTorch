$ ->
  $('#sidebar .btn').on 'click', (event)->
    btn = $(this)
    $.each($('#sidebar .btn.active'), ->
      unless btn is $(this)
        $(this).removeClass('active')
    )
    btn.addClass('active')