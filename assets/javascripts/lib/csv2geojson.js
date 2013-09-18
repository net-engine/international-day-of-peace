(function(e){if("function"==typeof bootstrap)bootstrap("csv2geojson",e);else if("object"==typeof exports)module.exports=e();else if("function"==typeof define&&define.amd)define(e);else if("undefined"!=typeof ses){if(!ses.ok())return;ses.makeCsv2geojson=e}else"undefined"!=typeof window?window.csv2geojson=e():global.csv2geojson=e()})(function(){var e,t,n,r,i;return function s(e,t,n){function r(o,u){if(!t[o]){if(!e[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=t[o]={exports:{}};e[o][0].call(f.exports,function(t){var n=e[o][1][t];return r(n?n:t)},f,f.exports,s,e,t,n)}return t[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<n.length;o++)r(n[o]);return r}({1:[function(e,t,n){},{}],dsv:[function(e,t,n){t.exports=e("dvu7iV")},{}],3:[function(e,t,n){function s(e){return!!e.match(/(Lat)(itude)?/gi)}function o(e){return!!e.match(/(L)(on|ng)(gitude)?/i)}function u(e){return typeof e=="object"?Object.keys(e).length:0}function a(e){var t=[",",";","	","|"],n=[];return t.forEach(function(t){var i=r(t).parse(e);if(i.length>=1){var s=u(i[0]);for(var o=0;o<i.length;o++)if(u(i[o])!==s)return}n.push({delimiter:t,arity:Object.keys(i[0]).length})}),n.length?n.sort(function(e,t){return t.arity-e.arity})[0].delimiter:null}function f(e){var t=a(e);return t?r(t).parse(e):null}function l(e,t,n){n||(n=t,t={}),t.delimiter=t.delimiter||",";var u=t.latfield||"",f=t.lonfield||"",l=[],c={type:"FeatureCollection",features:l};if(t.delimiter==="auto"&&typeof e=="string"){t.delimiter=a(e);if(!t.delimiter)return n({type:"Error",message:"Could not autodetect delimiter"})}var h=typeof e=="string"?r(t.delimiter).parse(e):e;if(!h.length)return n(null,c);if(!u||!f){for(var p in h[0])!u&&s(p)&&(u=p),!f&&o(p)&&(f=p);if(!u||!f){var d=[];for(var v in h[0])d.push(v);return n({type:"Error",message:"Latitude and longitude fields not present",data:h,fields:d})}}var m=[];for(var g=0;g<h.length;g++)if(h[g][f]!==undefined&&h[g][f]!==undefined){var y=h[g][f],b=h[g][u],w,E,S;S=i(y,"EW"),S&&(y=S),S=i(b,"NS"),S&&(b=S),w=parseFloat(y),E=parseFloat(b),isNaN(w)||isNaN(E)?m.push({message:"A row contained an invalid value for latitude or longitude",row:h[g]}):(t.includeLatLon||(delete h[g][f],delete h[g][u]),l.push({type:"Feature",properties:h[g],geometry:{type:"Point",coordinates:[parseFloat(w),parseFloat(E)]}}))}n(m.length?m:null,c)}function c(e){var t=e.features,n={type:"Feature",geometry:{type:"LineString",coordinates:[]}};for(var r=0;r<t.length;r++)n.geometry.coordinates.push(t[r].geometry.coordinates);return n.properties=t[0].properties,{type:"FeatureSet",features:[n]}}function h(e){var t=e.features,n={type:"Feature",geometry:{type:"Polygon",coordinates:[[]]}};for(var r=0;r<t.length;r++)n.geometry.coordinates[0].push(t[r].geometry.coordinates);return n.properties=t[0].properties,{type:"FeatureSet",features:[n]}}var r=e("dsv"),i=e("sexagesimal");t.exports={isLon:o,isLat:s,csv:r.csv.parse,tsv:r.tsv.parse,dsv:r,auto:f,csv2geojson:l,toLine:c,toPolygon:h}},{dsv:"dvu7iV",sexagesimal:5}],dvu7iV:[function(e,t,n){var r=e("fs");t.exports=(new Function('dsv.version = "0.0.2";\n\ndsv.tsv = dsv("\\t");\ndsv.csv = dsv(",");\n\nfunction dsv(delimiter) {\n  var dsv = {},\n      reFormat = new RegExp("[\\"" + delimiter + "\\n]"),\n      delimiterCode = delimiter.charCodeAt(0);\n\n  dsv.parse = function(text, f) {\n    var o;\n    return dsv.parseRows(text, function(row, i) {\n      if (o) return o(row, i - 1);\n      var a = new Function("d", "return {" + row.map(function(name, i) {\n        return JSON.stringify(name) + ": d[" + i + "]";\n      }).join(",") + "}");\n      o = f ? function(row, i) { return f(a(row), i); } : a;\n    });\n  };\n\n  dsv.parseRows = function(text, f) {\n    var EOL = {}, // sentinel value for end-of-line\n        EOF = {}, // sentinel value for end-of-file\n        rows = [], // output rows\n        N = text.length,\n        I = 0, // current character index\n        n = 0, // the current line number\n        t, // the current token\n        eol; // is the current token followed by EOL?\n\n    function token() {\n      if (I >= N) return EOF; // special case: end of file\n      if (eol) return eol = false, EOL; // special case: end of line\n\n      // special case: quotes\n      var j = I;\n      if (text.charCodeAt(j) === 34) {\n        var i = j;\n        while (i++ < N) {\n          if (text.charCodeAt(i) === 34) {\n            if (text.charCodeAt(i + 1) !== 34) break;\n            ++i;\n          }\n        }\n        I = i + 2;\n        var c = text.charCodeAt(i + 1);\n        if (c === 13) {\n          eol = true;\n          if (text.charCodeAt(i + 2) === 10) ++I;\n        } else if (c === 10) {\n          eol = true;\n        }\n        return text.substring(j + 1, i).replace(/""/g, "\\"");\n      }\n\n      // common case: find next delimiter or newline\n      while (I < N) {\n        var c = text.charCodeAt(I++), k = 1;\n        if (c === 10) eol = true; // \\n\n        else if (c === 13) { eol = true; if (text.charCodeAt(I) === 10) ++I, ++k; } // \\r|\\r\\n\n        else if (c !== delimiterCode) continue;\n        return text.substring(j, I - k);\n      }\n\n      // special case: last token before EOF\n      return text.substring(j);\n    }\n\n    while ((t = token()) !== EOF) {\n      var a = [];\n      while (t !== EOL && t !== EOF) {\n        a.push(t);\n        t = token();\n      }\n      if (f && !(a = f(a, n++))) continue;\n      rows.push(a);\n    }\n\n    return rows;\n  };\n\n  dsv.format = function(rows) {\n    if (Array.isArray(rows[0])) return dsv.formatRows(rows); // deprecated; use formatRows\n    var fieldSet = {}, fields = [];\n\n    // Compute unique fields in order of discovery.\n    rows.forEach(function(row) {\n      for (var field in row) {\n        if (!(field in fieldSet)) {\n          fields.push(fieldSet[field] = field);\n        }\n      }\n    });\n\n    return [fields.map(formatValue).join(delimiter)].concat(rows.map(function(row) {\n      return fields.map(function(field) {\n        return formatValue(row[field]);\n      }).join(delimiter);\n    })).join("\\n");\n  };\n\n  dsv.formatRows = function(rows) {\n    return rows.map(formatRow).join("\\n");\n  };\n\n  function formatRow(row) {\n    return row.map(formatValue).join(delimiter);\n  }\n\n  function formatValue(text) {\n    return reFormat.test(text) ? "\\"" + text.replace(/\\"/g, "\\"\\"") + "\\"" : text;\n  }\n\n  return dsv;\n}\n;return dsv'))()},{fs:1}],5:[function(e,t,n){t.exports=function(e,t){t||(t="NSEW");if(typeof e!="string")return null;var n=/^([0-9.]+)°? *(?:([0-9.]+)['’′‘] *)?(?:([0-9.]+)(?:''|"|”|″) *)?([NSEW])?/,r=e.match(n);return r?r[4]&&t.indexOf(r[4])===-1?null:((r[1]?parseFloat(r[1]):0)+(r[2]?parseFloat(r[2])/60:0)+(r[3]?parseFloat(r[3])/3600:0))*(r[4]&&r[4]==="S"||r[4]==="W"?-1:1):null}},{}]},{},[3])(3)});