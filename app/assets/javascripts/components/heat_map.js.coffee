class @HeatMap

  constructor: (map_data, containerId)->
    containerId =  if !(typeof containerId == 'undefined') then containerId else 'map-canvas'
    mapOptions = {
      zoom: 9,
      center: new google.maps.LatLng(29.76019,	-95.36939),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };

    property_data = []
    $.each(map_data, (idx, arr)->
      $.each(arr, (idx, coord)->
        property_data.push(new google.maps.LatLng(coord[0], coord[1]))
      )
    )

    try
      @map = new google.maps.Map(document.getElementById(containerId), mapOptions);
    catch e
      notify('error', 'You need to specify a containerId or have a div with id=#map-canvas. Data not loaded on the map.')
      return false


    @pointArray = new google.maps.MVCArray(property_data);

    @heatmap = new google.maps.visualization.HeatmapLayer({
      data: @pointArray
    });

    @heatmap.setMap(@map);

  toggleHeatmap: ->
    @heatmap.setMap(@heatmap.getMap() ? null : @map);

  changeGradient: ->
    gradient = [
      'rgba(0, 255, 255, 0)',
      'rgba(0, 255, 255, 1)',
      'rgba(0, 191, 255, 1)',
      'rgba(0, 127, 255, 1)',
      'rgba(0, 63, 255, 1)',
      'rgba(0, 0, 255, 1)',
      'rgba(0, 0, 223, 1)',
      'rgba(0, 0, 191, 1)',
      'rgba(0, 0, 159, 1)',
      'rgba(0, 0, 127, 1)',
      'rgba(63, 0, 91, 1)',
      'rgba(127, 0, 63, 1)',
      'rgba(191, 0, 31, 1)',
      'rgba(255, 0, 0, 1)'
    ]
    @heatmap.set('gradient', @heatmap.get('gradient') ? null : gradient);

  changeRadius: ->
    @heatmap.set('radius', @heatmap.get('radius') ? null : 20);

  changeOpacity: ->
    @heatmap.set('opacity', @heatmap.get('opacity') ? null : 0.2);
