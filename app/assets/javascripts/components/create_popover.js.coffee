class @CreatePopovers

  constructor: (data, options={})->

    createLink = options.createLink or false;

    $.each(data, (property, value) ->

      icon = $(".desktop-icon[class~=#{property}]");

      if createLink
        icon.click ->
          window.location = "/#{property}"

      title = data[property].title
      body  = data[property].content;

      icon.popover({
        animation: true,
        title:     title,
        content:   body,
        placement: 'bottom',
        delay:     {show:100, hide:100},
        trigger:   'hover'
      });

    )
