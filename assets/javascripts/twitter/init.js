(function(){$(function(){var e,t,n;return e=new TweetRetriever("#smallbusinessweek"),t=new TweetsMapDisplayer,n=new TweetsStripDisplayer(10,$("#info-box-tweets .info-box-body")),e.start(function(e,n,r){return t.addTweetToMap(e,n,r)},function(e){return n.addTweetToStrip(e)})})}).call(this);