$ ->
  # starting a twitter feed on the entire globe:
  # Example with location filter
  #tweetRetriever       = new TweetRetriever("%23" + $('#hashtag').val(), '-22,150,1500mi')
  tweetRetriever1       = new TweetRetriever("#smallbusinessweek")
  # tweetRetriever2       = new TweetRetriever("#buylocallyqld")
  tweetsMapDisplayer    = new TweetsMapDisplayer()

  tweetsStripDisplayer  = new TweetsStripDisplayer(10, $("#info-box-tweets .info-box-body"))
  tweetRetriever1.start (tweet, lat, lon) ->
    tweetsMapDisplayer.addTweetToMap(tweet, lat, lon)
  , (tweet) ->
    tweetsStripDisplayer.addTweetToStrip(tweet)

  # tweetRetriever2.start (tweet, lat, lon) ->
  #   tweetsMapDisplayer.addTweetToMap(tweet, lat, lon)
  # , (tweet) ->
  #   tweetsStripDisplayer.addTweetToStrip(tweet)
