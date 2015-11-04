#
# URLと関数をセットで登録する。
# 登録済みのURLで起動すると、関数が呼び出される。引数はplaceholderの変数。
#
module.exports = class Router
  constructor: ()->
    @_map = {}
    @_mapped = {}
    @_normalized = {}

  #
  # URLと関数のセットを登録する
  #
  # = Options
  #
  # - url URL
  # - app 関数。引数にはplaceholderから得られた変数が入る。
  #
  # = Examples
  #
  #   router.execute('/user')   # => 'index'
  #   router.execute('/user/1') # => 'user 1'
  #
  add: (url, app)->
    return false if @_find(url)

    normalized = @_normalize(url)

    now = @_map
    for i, name of normalized[0].split('/')
      continue if name == ''
      now[name] ?=  {}
      now = now[name]
    now._app = app
    now._parameters = normalized[1].split(':')

    @_mapped[normalized[0]] = true

  #
  # URLでルートを呼び出す
  #
  # = Options
  #
  # - url URL
  #
  # = Examples
  #
  #   router.add('/user', ()-> 'index')
  #   router.add('/user/:id', (params)-> "id #{params.id}")
  #
  execute: (url) ->
    store = []

    # mapを掘っていく
    now = @_map
    for i, name of @_strip(url).split('/')
      if now[name]
        now = now[name]
      else if now[':']
        store.push(name)
        now = now[':']

    # 得たパラメーターの振りわけ
    params = {}
    for i, name of now._parameters
      params[name] = store[i]

    # 起動
    now._app(params)

  #
  # private
  #

  _find: (url) ->
    normalized = @_normalize(url)
    @_mapped[normalized[0]]

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
    url.replace(/\/$/ig, '').replace(/.+?:\/\/(.+?)\//, '/').replace(/\?.*/, '')

