class @TweetsStripDisplayer
  constructor : (@maxTweetNumber, @$stripFeed)->
    @lastTweets = []
    @initializeStrip()

  addTweetToStrip : (tweet) ->
    @handleData(tweet)
    @redrawStripContent()


  handleData : (tweet) ->
    @lastTweets.splice(@maxTweetNumber - 1, 1) if (@lastTweets.length == @maxTweetNumber)
    @lastTweets.unshift(tweet)


  initializeStrip : ->
    # @$stripFeed.show() if (!@$stripFeed.is(":visible"))
    #@$stripFeed.mCustomScrollbar
    #  scrollButtons:
    #    enable:true


  redrawStripContent : ->
    @$stripFeed.find("ul").remove()
    @$stripFeed.append($('<ul></ul>'))
    $ul = @$stripFeed.find("ul")
    for lastTweet in @lastTweets
      $li     = $('<li></li>')
      $img    = $('<img/>')
      $span   = $('<span class="time"></span>')
      $strong = $('<strong></strong>')
      $p      = $('<p class="tweet"></p>')
      $img.load().attr( "src", lastTweet.user.profile_image_url )
      $span.text(tweeterUtils.formatDate(new Date(lastTweet.created_at)) )
      $strong.html(tweeterUtils.buildLinksForText("@"+lastTweet.user.screen_name) + ": ")
      $p.html(tweeterUtils.buildLinksForText(lastTweet.text))
      _.each [$img, $span, $strong, $p], (jQueryElement, index) ->
        $li.append(jQueryElement)

      $ul.append($li)

    #@$stripFeed.mCustomScrollbar("update")
