# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

getHeight = ->
  $(window).innerHeight() - 150;

getCalendarHeaderHeight = ->
  $('table.fc-header').height() + 7

$ ->

  $(document).on 'nested:fieldAdded', ->
    console.log('field added')
    initialize_search('service-search')

  $("#calendar").fullCalendar({
    header:
      left: 'title'
      center: 'month,agendaWeek,agendaDay'
      right: 'prev,today,next'
    contentHeight: getHeight()
    events:'/calendar_data'
    editable: true
    windowResize: ->
      $("#calendar").fullCalendar('option', 'contentHeight', getHeight());
      $('#icon-container').css({'margin-top': getCalendarHeaderHeight(), 'height':getHeight()});
    eventClick: (event, jsEvent)->
      element = $(jsEvent.target)
      setPopOver(event, element)
    eventDragStart: (event, jsEvent, ui, view)->
      unless event.editable
        alert('This event is already invoiced and can not be altered.')
    eventDrop: (event, dayDelta, minuteDelta, allDay, revertFunc, jsEvent, ui, view)->
      updateEvent(event, dayDelta, minuteDelta, revertFunc, jsEvent, ui, view)
    eventResize: (event, dayDelta, minuteDelta, revertFunc, jsEvent, ui, view)->
      updateEvent(event, dayDelta, minuteDelta, revertFunc, jsEvent, ui, view)
    eventRender: (event, element) ->
      element.bind 'dblclick', ()->
        triggerEventEdit(event)
    eventAfterAllRender: ->
      allowCreateEvent()
  });

  #set default height of sidebar
  $('#icon-container').css({'margin-top': getCalendarHeaderHeight(), 'height':getHeight()});

  setPopOver = (event, element) ->
    unless $('.popover:visible').length
      $.ajax({
        url:  "/events/#{event.id}"
        async: true
        dataType:'html'
        error: (jqXHR, status, error) ->
          console.log(error)
        success: (data, status, jqXHR) ->
          content = $(data).find('.content')
          element.popover({
            placement:'bottom'
            trigger:'click'
            animation:true
            delay:
              show:100
              hide:0
            html:true
            content:content
            container:'body'
          })

          element.on 'mouseleave', ->
            setTimeout( ->
              unless $('.popover:hover').length
                element.popover('hide')
            ,50
            )
            $('.popover:hover').on 'mouseleave', ->
              setTimeout( ->
                unless $('.popover:hover').length
                  element.popover('hide')
              ,50
              )

          element.popover('show')
    });


  updateEvent = (event, dayDelta, minuteDelta, revertFunc, jsEvent, ui, view)->
    $.ajax({
      type:'PUT'
      dataType:'JSON'
      url:"/events/#{event.id}"
      data:
        event:
          start:event.start
          end:event.end
          all_day:event.allDay
      error: (jqXHR, status, error)->
        console.log("Error - #{error}")
        revertFunc()
        notify('error', 'Sorry about this, but that date is unavailable right now.')
      success: (data, status, jqXHR)->
        console.log(status)
      complete: ->
        $('#calendar').fullCalendar('refetchEvents')
    })

  allowCreateEvent = ->
    $('td.fc-day').on 'dblclick', ->
      $.ajax({
        url:"/events/new?start=#{$(this).data('date')}"
        dataType:'script'
      })

  triggerEventEdit = (event)->
    if event.editable
      $.ajax({
        url:"events/#{event.id}/edit"
        dataType:'script'
      })
    else
      notify('error', 'Invoiced events cannot be edited.')