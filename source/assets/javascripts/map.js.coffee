
invasions = [
  {
    year: 2008
    invader: "Australia"
    invaded: "India"
    journey: [[-27.4710,153.0240], [21,78]]
  },
  {
    year: 2008
    invader: "Chad"
    invaded: "Australia"
    journey: [[10,18], [-27.4710,153.0240]]
  }
]


$ ->
  window.map = L.mapbox.map('map', 'netengine.map-vfsy08ln')
    .setView([2.3167,111.55], 3)

  setTimeout (->
    animation()
  ), 1000


animation = ->
  polyline_options =
    color: 'white'

  $.eachStep invasions, 4000, (i, invasion) ->
    journey = invasion.journey
    icon = L.divIcon
      className: "invasion"
      html: "<div class='tooltip'>#{invasion.year} <strong>#{invasion.invader}</strong> invaded <strong>#{invasion.invaded}</strong></div>"

    marker = L.marker(journey[0],
      icon: icon
    ).addTo map
    polyline = L.polyline(journey, polyline_options).addTo(map)

    setTimeout (->
      marker.setLatLng journey[1]
      setTimeout (->
        map.removeLayer(polyline)
        $(marker._icon).addClass('finished')
      ), 2250
    ), 500
