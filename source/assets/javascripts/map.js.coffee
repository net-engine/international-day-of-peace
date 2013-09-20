
# Init

duration = 1800
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
    .setView([31.5,-12.4], 2)

  decades = $.getValues "#{basepath}/javascripts/data/invasions-data.json"
  window.decades = decades.features

  window.boundaries_data = $.getValues "#{basepath}/javascripts/data/countries.geojson"

  boundaries = L.geoJson(boundaries_data,
    style: (feature) ->
      color: "red"
      weight: 1,
      fillOpacity: 0.1
    # onEachFeature: onEachFeature
  )

  boundaries.addTo(map);

  window.graph1_data = [
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


  window.graph2_data = [
    { y: "1990", "europe": 3, "middleast": 7, "asia": 21, "africa": 13, "americas": 6 }
    { y: "1991", "europe": 7, "middleast": 8, "asia": 15, "africa": 17, "americas": 5 }
    { y: "1992", "europe": 8, "middleast": 7, "asia": 19, "africa": 14, "americas": 4 }
    { y: "1993", "europe": 9, "middleast": 7, "asia": 15, "africa": 11, "americas": 3 }
    { y: "1994", "europe": 5, "middleast": 6, "asia": 16, "africa": 15, "americas": 4 }
    { y: "1995", "europe": 5, "middleast": 6, "asia": 16, "africa": 10, "americas": 4 }
    { y: "1996", "europe": 1, "middleast": 7, "asia": 18, "africa": 12, "americas": 3 }
    { y: "1997", "europe": 0, "middleast": 4, "asia": 19, "africa": 14, "americas": 2 }
    { y: "1998", "europe": 2, "middleast": 3, "asia": 16, "africa": 17, "americas": 2 }
    { y: "1999", "europe": 3, "middleast": 3, "asia": 15, "africa": 16, "americas": 2 }
    { y: "2000", "europe": 1, "middleast": 3, "asia": 17, "africa": 15, "americas": 1 }
    { y: "2001", "europe": 2, "middleast": 3, "asia": 14, "africa": 16, "americas": 2 }
    { y: "2002", "europe": 1, "middleast": 2, "asia": 12, "africa": 15, "americas": 2 }
    { y: "2003", "europe": 1, "middleast": 3, "asia": 15, "africa": 11, "americas": 1 }
    { y: "2004", "europe": 2, "middleast": 3, "asia": 14, "africa": 10, "americas": 3 }
    { y: "2005", "europe": 2, "middleast": 5, "asia": 17, "africa": 7, "americas": 2 }
    { y: "2006", "europe": 1, "middleast": 5, "asia": 16, "africa": 10, "americas": 2 }
    { y: "2007", "europe": 2, "middleast": 4, "asia": 14, "africa": 12, "americas": 3 }
    { y: "2008", "europe": 2, "middleast": 4, "asia": 16, "africa": 13, "americas": 3 }
    { y: "2009", "europe": 1, "middleast": 5, "asia": 15, "africa": 12, "americas": 3 }
    { y: "2010", "europe": 1, "middleast": 5, "asia": 12, "africa": 10, "americas": 3 }
    { y: "2011", "europe": 1, "middleast": 6, "asia": 13, "africa": 15, "americas": 2 }
    { y: "2012", "europe": 2, "middleast": 5, "asia": 10, "africa": 13, "americas": 2 }
  ]

  window.graph_options =
    # events: ["2013-09-21"]
    eventLineColors: ['whitesmoke']
    eventStrokeWidth: 2
    stacked: true
    xkey: 'y'
    gridTextFamily: 'Lora',
    gridTextColor: 'hsl(0, 25%, 10%)'
    pointSize: 0
    lineWidth: 3
    hideHover: true
    smooth: false
    fillOpacity: .45
    lineColors: ['black', 'maroon', 'red', 'orange', 'yellow']

  graph1_options =
    element: 'chart1'
    data: graph1_data
    ykeys: ['war', 'minor']
    labels: ['War', 'Minor']

  window.graph1 = Morris.Area($.extend(graph1_options, graph_options))

  graph2_options =
    element: 'chart2'
    data: graph2_data
    ykeys: ['europe', 'middleast', 'asia', 'africa', 'americas']
    labels: ['Europe', 'Middle East', 'Asia', 'Africa', 'Americas']

  window.graph2 = Morris.Area($.extend(graph2_options, graph_options))


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


window.toggleChart = (time = 150) ->
  chart = $('#chart-box')

  $('.column').toggleClass('large')

  setTimeout (->
    chart.find('svg').attr('height', chart.height()).attr('width', chart.width())
    graph1.redraw()
    graph2.redraw()
  ), time


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
  toggleChart()
  $("#info, .invasion-info.box").show()


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

    $('.chart-wrapper').toggleClass('active');

    # console.log decade.decade

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
        toggleChart()
        $("#info, .invasion-info.box").fadeOut()
      ), full_duration * 2

      setTimeout (->
        restart()
      ), full_duration * 4



# Event listeners

$(document).on 'click', '#refresh', (e) ->
  restart()
  $(this).hide()
