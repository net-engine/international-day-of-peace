class @TwitterClient
  constructor: ->
    @cb = new Codebird()
    # https://dev.twitter.com/apps/4612959/show net_engine twitter account
    @cb.setConsumerKey('AmreN4WnQZ0H1LvtULjvQA', 'PaDBBTS0O4SUeKgCUmTN36uFeFehBsZPPdHjf5d0')
    @initialized = false

  afterInitialize : (callback) ->
    @cb.__call('oauth2_token', {}, (reply) =>
      @cb.setBearerToken(reply.access_token)
      @initialized = true
      callback()
    )

  get : (query, handleResults) ->
    throw new Error("TwitterClient not initialized. Please use afterInitialize method.") unless @initialized
    @cb.__call('search_tweets',query, (reply) ->
      handleResults(reply)
    , true)