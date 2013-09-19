class @TweetsMapDisplayer
  constructor: ->


  addTweetToMap : (tweet, lat, lon) ->
    html   = @buildHTMLFromElement(tweet, lat, lon)
    myIcon = L.divIcon({className: 'tweets-marker-icon', html: html.innerHTML})
    L.marker([lat, lon], {icon: myIcon}).addTo(map)
    #rebind hover and click actions
    @bindTweetActions()


  buildHTMLFromElement : (tweet, lat, lon) ->
    d       = document.createElement('div')
    overlay = document.createElement('div')
    footer  = document.createElement('div')
    user    = document.createElement('div')
    time    = document.createElement('div')

    d.className       = 'tweets-marker-icon'
    overlay.innerHTML = tweeterUtils.buildLinksForText(tweet.text)
    overlay.className = 'tweet-overlay'
    user.innerHTML    = tweeterUtils.buildLinksForText('@' + tweet.user.screen_name)
    user.className    = 'user'
    time.innerHTML    = tweeterUtils.formatDate(new Date(tweet.created_at))
    time.className    = 'time'
    footer.appendChild(user)
    footer.appendChild(time)
    overlay.appendChild(footer)
    overlay.setAttribute('data-lon', lon)
    overlay.setAttribute('data-lat', lat)
    overlay.setAttribute('id', tweet.id)
    d.appendChild(overlay)
    return d


  bindTweetActions : ->
    _this = @

    $('.tweets-marker-icon').hover ->
      if $(this).attr("id")!= _this.getCurrentTweetId()
        _this.hidePreviousTweets()
        _this.showCurrentTweet(@)
    , null

    $('.tweets-marker-icon').unbind('click touchstart')
    $('.tweets-marker-icon').bind 'click touchstart', ->
      _this.hidePreviousTweets()
      _this.showCurrentTweet($(@))
      _this.zoom($(@).find(".tweet-overlay").data())

  zoom : ($data) ->
    map.panTo([$data.lat, $data.lon])
    # map.setZoom(12)
    map.panTo([$data.lat, $data.lon])


  hidePreviousTweets : ->
    $('.tweets-marker-icon').find('.tweet-overlay').hide()

  getCurrentTweetId : ->
    $tweet = $('.tweets-marker-icon').find('.tweet-overlay:visible')
    return undefined unless $tweet
    return $tweet.parent().attr('id')


  showCurrentTweet : ($tweet) ->
    return false unless $tweet
    $('.info-tooltip').hide()
    $('.leaflet-marker-icon').removeClass('active')

    $("#info-box-tweets .info-box-title").click()
    
    $tweet.find('.tweet-overlay').show()
