(function(e){window.requestAnimFrame=function(){return window.requestAnimationFrame||window.webkitRequestAnimationFrame||window.mozRequestAnimationFrame||window.oRequestAnimationFrame||window.msRequestAnimationFrame||function(e,t){window.setTimeout(e,1e3/60)}}(),window.requestTimeout=function(e,t){function i(){var s=(new Date).getTime(),o=s-n;o>=t?e.call():r.value=requestAnimFrame(i)}if(!window.requestAnimationFrame&&!window.webkitRequestAnimationFrame&&(!window.mozRequestAnimationFrame||!window.mozCancelRequestAnimationFrame)&&!window.oRequestAnimationFrame&&!window.msRequestAnimationFrame)return window.setTimeout(e,t);var n=(new Date).getTime(),r=new Object;return r.value=requestAnimFrame(i),r},window.clearRequestTimeout=function(e){window.cancelAnimationFrame?window.cancelAnimationFrame(e.value):window.webkitCancelRequestAnimationFrame?window.webkitCancelRequestAnimationFrame(e.value):window.mozCancelRequestAnimationFrame?window.mozCancelRequestAnimationFrame(e.value):window.oCancelRequestAnimationFrame?window.oCancelRequestAnimationFrame(e.value):window.msCancelRequestAnimationFrame?msCancelRequestAnimationFrame(e.value):clearTimeout(e)},e.eachStep=function(t,n,r){var i="200",s=0;return typeof n=="function"?r=n:i=n,i=="slow"&&(i=600),i=="fast"&&(i=200),typeof r!="function"?!1:e.each(t,function(e,t){window.requestTimeout(function(){r(e,t,i)},i*s),s++})},e.fn.eachStep=function(e,t){var n="200";return typeof e=="function"?t=e:n=e,n=="slow"&&(n=600),n=="fast"&&(n=200),typeof t!="function"?!1:this.each(function(e,r){window.requestTimeout(function(){t(e,r,n)},n*e)})}})(jQuery);