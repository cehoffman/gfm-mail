fs = require 'fs'
path = require 'path'

html = ''
process.stdin.on 'data', (d) -> html += d
process.stdin.on 'end', () ->
  cheerio = require 'cheerio'
  $ = cheerio.load(html, decodeEntities: false)

  css = $('style').text()

  # Remove the name of the document
  $('h3').eq(0).remove()

  # Octicons are broken so just remove them
  $('.octicon').each (i, node) ->
    $this = $(this)
    cls = $this.attr('class').replace /\s?octicon-[a-z]+/, ''
    $this.attr('class', cls)

  uncss = require('uncss')
  uncss html, {raw: css}, (err, out) ->
    return if err

    out = (new (require('clean-css'))).minify(out)
    $('style').remove()
    $('head').append("<style>#{out}</style>")
    # htmlminify = require('html-minifier').minify
    console.log $.html()
      # removeComments: true
      # collapseWhitespace: true
      # # conservativeCollapse: true
      # minifyJS: true,
      # minifyCSS: true
