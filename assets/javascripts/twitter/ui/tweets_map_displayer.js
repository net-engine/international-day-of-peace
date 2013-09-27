(function(){this.TweetsMapDisplayer=function(){function e(){}return e.prototype.addTweetToMap=function(e,t,n){var r,i;return r=this.buildHTMLFromElement(e,t,n),i=L.divIcon({className:"tweets-marker-icon",html:r.innerHTML}),L.marker([t,n],{icon:i}).addTo(map),this.bindTweetActions(),setTimeout(function(){return $("tweet-overlay").fadeOut()},6e3)},e.prototype.buildHTMLFromElement=function(e,t,n){var r,i,s,o,u;return r=document.createElement("div"),s=document.createElement("div"),i=document.createElement("div"),u=document.createElement("div"),o=document.createElement("div"),r.className="tweets-marker-icon",s.innerHTML=tweeterUtils.buildLinksForText(e.text),s.className="tweet-overlay",u.innerHTML=tweeterUtils.buildLinksForText("@"+e.user.screen_name),u.className="user",o.innerHTML=tweeterUtils.formatDate(new Date(e.created_at)),o.className="time",i.appendChild(u),i.appendChild(o),s.appendChild(i),s.setAttribute("data-lon",n),s.setAttribute("data-lat",t),s.setAttribute("id",e.id),r.appendChild(s),r},e.prototype.bindTweetActions=function(){var e;return e=this,$(".tweets-marker-icon").hover(function(){if($(this).attr("id")!==e.getCurrentTweetId())return e.hidePreviousTweets(),e.showCurrentTweet(this)},null),$(".tweets-marker-icon").unbind("click touchstart"),$(".tweets-marker-icon").bind("click touchstart",function(){return e.hidePreviousTweets(),e.showCurrentTweet($(this)),e.zoom($(this).find(".tweet-overlay").data())})},e.prototype.zoom=function(e){return map.panTo([e.lat,e.lon]),map.panTo([e.lat,e.lon])},e.prototype.hidePreviousTweets=function(){return $(".tweets-marker-icon").find(".tweet-overlay").hide()},e.prototype.getCurrentTweetId=function(){var e;return e=$(".tweets-marker-icon").find(".tweet-overlay:visible"),e?e.parent().attr("id"):void 0},e.prototype.showCurrentTweet=function(e){return e?($(".info-tooltip").hide(),$(".leaflet-marker-icon").removeClass("active"),$("#info-box-tweets .info-box-title").click(),e.find(".tweet-overlay").show()):!1},e}()}).call(this);