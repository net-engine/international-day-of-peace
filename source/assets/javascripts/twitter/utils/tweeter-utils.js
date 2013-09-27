var tweeterUtils = (function(){
  var extractUserNames = function(text){
    // Regexp to capture the following cases
    // username is at the beginning of the line then there is a space
    // username is at the beginning of the line and at the end of the line
    // username is between spaces
    // username is at the end of the line and there is a space before
    //return text.match(/(^|\W)(@\w+)/gi).join(" ").match(/(@\w+)/gi);
    return text.match(/\B@\w+/gi);
  };

  var extractHashTags  = function(text){
    return text.match(/\B#\w+/gi);
  };

  var extractURLs = function(text){
    return text.match(/[-a-zA-Z0-9@:%_\+.~#?&//=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?/gi);
  };

  var buildLinkForUsername = function(username){
    var username = username.substr(1);
    return "<a href=\"//twitter.com/"+ username +"\" target=\"_blank\">@"+username+"</a>";
  };

  var buildLinkForHashTag  = function(hashtag){
    var hashtag = hashtag.substr(1);
    return "<a href=\"//twitter.com/search?q=%23"+ hashtag +"\" target=\"_blank\">#"+hashtag+"</a>";
  };

  var buildLinkForStandardURL = function(link){
    var url    = link.replace(/\bhttp(s)*:\/\//,"");
    return "<a href=\"//"+ url +"\" target=\"_blank\">"+link+"</a>";
  };

  var buildLinksForText = function(text){
    var links = extractURLs(text);
    if (links){
      for (var i=0;i<links.length;i++){
        var link = links[i];
        var regex = new RegExp(link, "gi");
        text = text.replace(regex, buildLinkForStandardURL(link));
      }
    }

    var userNames = extractUserNames(text);
    if (userNames){
      for (var i=0;i<userNames.length;i++){
        var userName = userNames[i];
        var regex = new RegExp(userName, "gi");
        text = text.replace(regex, buildLinkForUsername(userName));
      }
    }

    var hashTags  = extractHashTags(text);
    if (hashTags){
      for (var i=0;i<hashTags.length;i++){
        var hashTag = hashTags[i];
        var regex = new RegExp(hashTag, "gi");
        text = text.replace(regex, buildLinkForHashTag(hashTag));
      }
    }

    return text;
  };

  /**
   * Helper method to format the date properly
   * @param d
   * @return {String}
   */
  var formatDate = function(d) {
    var hours = d.getHours();
    var minutes = d.getMinutes();
    var suffix = "AM";

    if (hours >= 12) {
      suffix = "PM";
      hours = hours - 12;
    }
    if (hours == 0) hours = 12;
    if (minutes < 10) minutes = "0" + minutes;

    return hours + ":" + minutes + " " + suffix;
  };

  return {
    buildLinksForText : buildLinksForText,
    formatDate        : formatDate
  };
})();