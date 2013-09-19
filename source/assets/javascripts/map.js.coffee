
# Init

duration = 1000
full_duration = duration * 15

$ ->
  if window.location.hostname is "net-engine.github.io"
    window.basepath = "http://net-engine.github.io/international-day-of-peace/assets"
  else
    window.basepath = "/assets"

  map_options =
    minZoom: 2
    noWrap: true

  window.map = L.mapbox.map('map', 'netengine.map-vfsy08ln', map_options)
    .setView([29,58], 2)

  decades = $.getValues "#{basepath}/javascripts/data/invasions-data.json"
  window.decades = decades.features

  window.boundaries_data = $.getValues "#{basepath}/javascripts/data/countries.geojson"

  boundaries = L.geoJson(boundaries_data,
    style: (feature) ->
      color: "red"
      weight: 1,
      fillOpacity: 0.1
    onEachFeature: onEachFeature
  )

  boundaries.addTo(map);

  window.graph = Morris.Area
    element: 'chart'
    # barColors: ['hsl(0,25%,15%)', 'maroon']
    stacked: true
    data: [
      { y: '1990', 'minor': 35, 'war': 15, 'total': 50 }
      { y: '1991', 'minor': 39, 'war': 13, 'total': 52 }
      { y: '1992', 'minor': 40, 'war': 12, 'total': 52 }
      { y: '1993', 'minor': 35, 'war': 10, 'total': 45 }
      { y: '1994', 'minor': 35, 'war': 11, 'total': 46 }
      { y: '1995', 'minor': 33, 'war': 8, 'total': 41 }
      { y: '1996', 'minor': 33, 'war': 8, 'total': 41 }
      { y: '1997', 'minor': 32, 'war': 7, 'total': 39 }
      { y: '1998', 'minor': 28, 'war': 12, 'total': 40 }
      { y: '1999', 'minor': 26, 'war': 13, 'total': 39 }
      { y: '2000', 'minor': 27, 'war': 10, 'total': 37 }
      { y: '2001', 'minor': 28, 'war': 9, 'total': 37 }
      { y: '2002', 'minor': 26, 'war': 6, 'total': 32 }
      { y: '2003', 'minor': 26, 'war': 5, 'total': 31 }
      { y: '2004', 'minor': 25, 'war': 7, 'total': 32 }
      { y: '2005', 'minor': 28, 'war': 5, 'total': 33 }
      { y: '2006', 'minor': 29, 'war': 5, 'total': 34 }
      { y: '2007', 'minor': 31, 'war': 4, 'total': 35 }
      { y: '2008', 'minor': 33, 'war': 5, 'total': 38 }
      { y: '2009', 'minor': 30, 'war': 6, 'total': 36 }
      { y: '2010', 'minor': 27, 'war': 4, 'total': 31 }
      { y: '2011', 'minor': 31, 'war': 6, 'total': 37 }
      { y: '2012', 'minor': 26, 'war': 6, 'total': 32 }
    ]
    xkey: 'y'
    ykeys: ['minor', 'war', 'total']
    labels: ['Minor', 'War', 'Total']
    gridTextFamily: 'Lora',
    gridTextColor: 'hsl(0, 25%, 10%)'
    pointSize: 0
    lineWidth: 3
    hideHover: true
    smooth: false
    fillOpacity: .45
    lineColors: ['black', 'maroon', 'red']

  setTimeout (->
    animation()
  ), 1500


  tweetRetriever1       = new TweetRetriever("#PeaceDay")
  tweetsMapDisplayer    = new TweetsMapDisplayer()
  tweetsStripDisplayer  = new TweetsStripDisplayer(20, $("#tweets"))

  tweetRetriever1.start (tweet, lat, lon) ->
    tweetsMapDisplayer.addTweetToMap(tweet, lat, lon)
  , (tweet) ->
    tweetsStripDisplayer.addTweetToStrip(tweet)


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
  chart = $('#chart-box')

  chart.toggleClass('large')
  setTimeout (->
    chart.find('svg').attr('height', chart.height()).attr('width', chart.width())
    graph.redraw()
  ), time + 10


onEachFeature = (feature, layer) ->
  layer.on
    click: (e) ->
      # console?.log e.target
      e.target.setStyle
        fillOpacity: .9
        fillColor: 'red'
        weight: 2

window.restart = ->
  map.removeLayer(featureGroup)
  animation()
  toggleChart(300)


window.animation = ->
  polyline_options =
    color: 'white'
    weight: 2
    # opacity: 0.5

  index = 0
  window.graphData = []

  $.eachStep decades, full_duration, (i, decade) ->
    index++
    count = decade.invasions.length

    map.removeLayer(featureGroup) if featureGroup?
    window.featureGroup = L.featureGroup().addTo(map)

    $('#info').html("<div class='decade-title'>#{decade.decade}</div>")

    $.eachStep decade.invasions, (full_duration / decade.invasions.length), (i, invasion) ->
      count--

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
      ), full_duration * 2

      setTimeout (->
        restart()
      ), full_duration * 4



# Event listeners

$(document).on 'click', '#refresh', (e) ->
  restart()
  $(this).hide()
