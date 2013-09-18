
# Init

duration = 1500

$ ->
  map_options =
    minZoom: 2
    noWrap: true

  window.map = L.mapbox.map('map', 'netengine.map-vfsy08ln', map_options)
    .setView([33.43144133557529,-84.638671875], 2)
    .fitWorld()

  decades = $.getValues "/assets/javascripts/data/test-data.json"
  window.decades = decades.features

  window.boundaries_data = $.getValues "/assets/javascripts/data/countries.geojson"

  boundaries = L.geoJson(boundaries_data,
    style: (feature) ->
      color: "red"
      weight: 1,
      fillOpacity: 0.1
    onEachFeature: onEachFeature
  )

  boundaries.addTo(map);


  window.graph = Morris.Bar
    element: 'chart'
    barColors: ['hsl(0,25%,10%)']
    stacked: true
    data: [
      { y: '1990 - 2000', a: '0' }
    ]
    xkey: 'y'
    ykeys: ['a']
    labels: ['Conflicts']
    gridTextFamily: 'Lora',
    gridTextColor: 'hsl(0, 25%, 10%)'

  setTimeout (->
    animation()
  ), 1500




jQuery.extend getValues: (url) ->
  result = null
  $.ajax
    url: url
    type: "get"
    dataType: "json"
    async: false
    success: (data) ->
      result = data

  result


window.toggleChart = (time) ->
  chart = $('#chart')

  chart.toggleClass('large')
  setTimeout (->
    chart.find('svg').attr('height', chart.height()).attr('width', chart.width())
    graph.redraw()
  ), time

onEachFeature = (feature, layer) ->
  layer.on
    click: (e) ->
      console?.log e.target
      e.target.setStyle
        fillOpacity: .9
        fillColor: 'red'
        weight: 2

window.restart = ->
  toggleChart(300)

  setTimeout (->
    animation()
  ), 1000


window.animation = ->
  polyline_options =
    color: 'white'
    weight: 2
    # opacity: 0.5

  index = 0
  window.graphData = []

  $.eachStep decades, decades[index].invasions.length * duration, (i, decade) ->
    index++
    count = decade.invasions.length

    map.removeLayer(featureGroup) if featureGroup?
    window.featureGroup = L.featureGroup().addTo(map)

    $('#info').html("<div class='decade-title'>#{decade.decade}</div>")

    $.eachStep decade.invasions, duration, (i, invasion) ->
      count--
      graphData[(index - 1)] =
        y: decade.decade
        a: i
      graph.setData(graphData)

      $('#invasion-info').html JST["templates/invasion-info"](invasion)

      journey = invasion.coordinates

      icon = L.divIcon
        className: "invasion"
        html: JST["templates/invasion"](invasion)

      window.marker = L.marker(journey[0],
        icon: icon
        riseOnHover: true
      ).addTo featureGroup

      polyline = L.polyline(journey, polyline_options).addTo(featureGroup)

      setTimeout (->
        marker.setLatLng journey[1]
        setTimeout (->
          featureGroup.removeLayer(polyline)
          $(marker._icon).addClass('finished')
        ), duration * .75
      ), duration / 10

      # if count is 0
      #   console?.log "#{decade.decade}: done"

    if index is decades.length
      setTimeout (->
        toggleChart(300)
        $('#refresh').show()
      ), (decades[decades.length - 1].invasions.length * duration) + duration



# Event listeners

$(document).on 'click', '#refresh', (e) ->
  restart()
  $(this).hide()
