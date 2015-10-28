module.exports = class Router
  constructor: ()->
    @map = {}
    @mapped = {}
    @_normalized = {}

  add: (url, app)->
    return false if @_find(url)

    normalized = @_normalize(url)

    now = @map
    for i, name of normalized[0].split('/')
      continue if name == ''
      now[name] ?=  {}
      now = now[name]
    now._app = app
    now._parameters = normalized[1].split(':')

    @mapped[normalized[0]] = true

  execute: (url) ->
    now = @map
    store = []
    for i, name of @_strip(url).split('/')
      if now[name]
        now = now[name]
      else if now[':']
        store.push(name)
        now = now[':']

    params = {}
    for i, name of now._parameters
      params[name] = store[i]

    now._app(params)

  _find: (url) ->
    normalized = @_normalize(url)
    @mapped[normalized[0]]

  _is_include_placeholder: (url)->
    url.match(/:[a-z_0-9]+/)?

  _normalize: (url) ->
    return @_normalized[url] if @_normalized[url]
    return @_normalized[url] = [@_strip(url), ''] unless @_is_include_placeholder(url)

    @_normalized[url] = @_pickHolder(url, [])

  _pickHolder: (url, holders)->
    result = url.match(/(:[a-z_0-9]+)/)

    return [@_strip(url), holders.join(':')] unless result

    @_pickHolder(url.replace(result[1], ':'), holders.concat(result[1].replace(':', '')))

  _strip: (url)->
    url.replace(/\/$/ig, '')

