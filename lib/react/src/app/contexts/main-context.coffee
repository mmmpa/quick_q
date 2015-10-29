#
# ReactApplicationの全てを統括するコンテキスト
#
# = Attributes
#
# - @content 実際にコンテンツを表示するルーター
# - @notifier 全ての前面に表示されるオーバーレイルーター
# - @menu グローバルメニューなどアプリケーション共通物を表示するルーター
#
module.exports = class MainContext extends Arda.Context
  _history = []
  _feature = []
  _now = 0

  component: App.View.Display

  initState: (props) -> props

  expandComponentProps: (props, state) -> props

  delegate: (subscribe) ->
    super

    subscribe 'context:created', @_initializeRouter
    subscribe 'context:created', @_initializeEventWatcher
    subscribe 'display:initialized', @_initializeDisplay
    subscribe 'scene:replace', @_replaceScene

    subscribe 'notify:success', (title, message)=>

    subscribe 'notify:fail', (title, message)=>

    subscribe 'reload', =>
      @update((state) => state)

  #
  # Initializer
  #

  _initializeEventWatcher: ->
    HistoryWard.startBrutally()
    $(window).on(HistoryWard.BACKWARD, @_backward)
    $(window).on(HistoryWard.FORWARD, @_forward)

  _initializeDisplay: (routers)->
    # このrouterはArda.Router
    @content = routers.content
    @notifier = routers.notifier
    @menu = routers.menu

    # 以降replaceContextで統一する
    @content.pushContext(App.BlankContext, {name: 'Content'}).done =>
      @_initializeScene()
    @notifier.pushContext(App.BlankContext, {name: 'Notifier'}).done =>
      @notifier.replaceContext(App.Notifier.GodContext, {})
    @menu.pushContext(App.BlankContext, {name: 'Menu'}).done =>
      @menu.replaceContext(App.Menu.GlobalContext, {})

  _initializeRouter: ->
    # これはuriから動作を振りわける一般的なルーター
    @router = new App.Router()
    @router.add('/', (params)-> new App.Cassette(App.PortalContext, params))

  _initializeScene: ->
    @content.pushContext(@_detectCassette().forPusher()...)
  #
  # History Manager
  #
  _backward: (e)=>
    @.emit 'scene:change',
      path: location.href
      unhistorize: true

  _forward: (e)=>
    @.emit 'scene:change',
      path: location.href
      unhistorize: true

  _pushHistory: (body, header, path)->
    if fitstHistroy
      fitstHistroy = false
      return
    _history = _history[0.._now]
    _now = _history.length
    _history.push({ body: body, header: header, path: path })
    history.pushState({ position: _history.length - 1 }, null, path)

  #
  # Helper
  #
  _detectCassette: ->
    @router.execute(@_strippedPath())

  _pickHeaderParameters: (xhr)->
    required = [
      'Total-Pages'
      'Per-Page'
      'Current-Page'
      'Paginate-Path'
      'Access-Level'
    ]
    _.reduce(required, (a, req)->
      console.log req
      a[req] = xhr.getResponseHeader(req)
      a
    , {})

  _strippedPath: ->
    location.href.replace(/.+?:\/\/(.+?)\//, '/')

  _isCrossDomain: (url)->
    originAnchor = document.createElement("a")
    originAnchor.href = location.href
    urlAnchor = document.createElement("a")

    try
      urlAnchor.href = url
      urlAnchor.href = urlAnchor.href

      return !urlAnchor.protocol || !urlAnchor.host ||
          (originAnchor.protocol + "//" + originAnchor.host !=
            urlAnchor.protocol + "//" + urlAnchor.host)
    catch e
      return true

  #
  #
  #

  _replaceScene: (linker) ->


