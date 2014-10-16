// Generated by CoffeeScript 1.7.1
var fs, html, path;

fs = require('fs');

path = require('path');

html = '';

process.stdin.on('data', function(d) {
  return html += d;
});

process.stdin.on('end', function() {
  var $, cheerio, css, uncss;
  cheerio = require('cheerio');
  $ = cheerio.load(html);
  css = $('style').text();
  $('h3').eq(0).remove();
  $('.octicon').each(function(i, node) {
    var $this, cls;
    $this = $(this);
    cls = $this.attr('class').replace(/\s?octicon-[a-z]+/, '');
    return $this.attr('class', cls);
  });
  uncss = require('uncss');
  return uncss(html, {
    raw: css
  }, function(err, out) {
    if (err) {
      return;
    }
    out = (new (require('clean-css'))).minify(out);
    $('style').remove();
    $('head').append("<style>" + out + "</style>");
    return console.log($.html());
  });
});