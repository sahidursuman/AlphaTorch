# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->

  options = $.extend(datatable_defaults(),
    "sAjaxSource": "/landscapers_data_tables_source",
    "aaSorting": [[4, "desc"]],
    "fnInitComplete": (oSettings, json)->
      $('.rating').rating(rating_defaults())
    ,
    "fnDrawCallback": (oSettings)->
      $('.rating').rating(rating_defaults())
  )
  $('#landscapers.datatable').dataTable(options);

  $('.datatable th').addClass('h4')
  # Validate form dynamically as user inputs information before submitting
  $ ->
    if $("#new_landscaper, #edit_landscaper").length
      $("#new_landscaper, #edit_landscaper").validate
        rules:
          'landscaper[first_name]':
            required: true
            minlength: 2

          'landscaper[last_name]':
            required: true
            minlength: 2

          'landscaper[email]':
            required: false
            email: true

          'landscaper[primary_phone]':
            required: true

        messages:
          'landscaper[first_name]':
            required: "* Enter landscapers's first name"
            minlength: "* {0} characters required"

          'landscaper[last_name]':
            required: "* Enter landscaper's last name"
            minlength: "* {0} characters required"

          'landscaper[email]':
            email: "* Please enter a valid email address"

          'landscaper[primary_phone]':
            required: "* Phone required"

        errorPlacement: (error, element) ->
          if element.parent().is(".input-append")
            error.appendTo element.parents(".controls:first")
          else
            error.insertAfter element