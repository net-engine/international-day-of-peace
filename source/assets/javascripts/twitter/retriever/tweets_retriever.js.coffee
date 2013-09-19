class @TweetRetriever
  constructor: (query, location = null, @timeBetweenQueries = 30000, pageSize = 10) ->
    @tc          = new TwitterClient()
    @queryParams =
      {
      q             : query,
      result_type   : "recent",
      count         : pageSize
      }
    @queryParams.geocode = location if location
    @cbOnLocatedTweet = @cbForAnyTweet = null


  start : (@cbOnLocatedTweet, @cbForAnyTweet) ->
    @tc.afterInitialize => @getTweets()


  getTweets : ->
    @tc.get @queryParams, (results) =>
      @processTweets(results)


  processTweets : (results) ->
    statuses = results.statuses.reverse() if results.statuses
    _.each statuses, (tweet, index) =>
      coordinates = @getTweetLocation(tweet)
      @cbOnLocatedTweet(tweet, coordinates[0], coordinates[1]) if coordinates &&  @cbOnLocatedTweet
      @cbForAnyTweet(tweet) if @cbForAnyTweet

    if results.search_metadata && results.search_metadata.refresh_url
      @queryParams.since_id  = results.search_metadata.max_id_str
      return setTimeout =>
        @getTweets()
      , @timeBetweenQueries
    else # if we do not have results.search_metadata.next_results, we are over the rate limit
      console?.log("limit reached, will try again in 5 minutes.")
      return setTimeout =>
        @getTweets()
      , 300000 # we wait 5 minutes and issue the same request which failed before


  getTweetLocation : (tweet) ->
    lat = lon = 0
    # Two possible places for location
    if (tweet.geo && tweet.geo.type == 'Point')
      lat = tweet.geo.coordinates[0]
      lon = tweet.geo.coordinates[1]

    else if (tweet.location && tweet.location.indexOf(': ') > 0)
      coords = tweet.location.split(': ')[1]
      lat    = coords.split(',')[0] || 0
      lon    = coords.split(',')[1] || 0

      if (!isNaN(parseFloat(lat)) && !isNaN(parseFloat(lon)))
        lat = parseFloat(lat)
        lon = parseFloat(lon)

    coordinates = null
    coordinates = [lat, lon] if lat != 0 && lon != 0
    return coordinates

