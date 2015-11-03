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
  component: React.createClass (
    mixins: [Arda.mixin]
    render: ->
      App.JSX.main()

    componentDidMount: ->
      routers = {
        content: new Arda.Router(Arda.DefaultLayout, React.findDOMNode(@refs.content))
        notifier: new Arda.Router(Arda.DefaultLayout, React.findDOMNode(@refs.notifier))
        menu: new Arda.Router(Arda.DefaultLayout, React.findDOMNode(@refs.menu))
      }
      console.log 'Display mounted', routers
      @dispatch 'display:initialized', routers
  )

  _history = []
  _feature = []
  _now = 0

  initState: (props) -> props

  expandComponentProps: (props, state) -> props

  delegate: (subscribe) ->
    super

    subscribe 'context:created', ()->
      @_initializeValuables()
      @_initializeRouter()
      @_initializeEventWatcher()

    subscribe 'display:initialized', @_initializeDisplay
    subscribe 'scene:replace', @_replaceScene

    subscribe 'notify:success', (title, message)=>

    subscribe 'notify:fail', (title, message)=>
    subscribe 'history:push', (linker)=> history.pushState({}, null, linker.paramsUri)

    subscribe 'reload', =>
      @update((state) => state)

    subscribe 'question:show', (q)->
      @_replaceScene(App.Linker.get(App.Path.q, id: q.id))

    subscribe 'inform:rendered', (q)->
      MathJax.Hub.Typeset()

    subscribe 'question:tagged:index', (id)->
      @_replaceScene(App.Linker.get(App.Path.taggedIndex, tags: [id]))


  #
  # Application method
  #

  strikeApi: (linker, forceReload)->
    App.ApiStriker.strike(linker, forceReload)

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
    @content.pushContext(App.BlankContext, { name: 'Content' }).done =>
      @_initializeScene()
    @notifier.pushContext(App.BlankContext, { name: 'Notifier' }).done =>
      @notifier.replaceContext(App.Notifier.GodContext, { root: @ })
    @menu.pushContext(App.BlankContext, { name: 'Menu' }).done =>
      @menu.replaceContext(App.Menu.GlobalContext, { root: @ })

  _initializeRouter: ->
    # 全てのコンテキストはメインコンテキストに通知を出せる
    App.Cassette.root = @

    # これはuriから動作を振りわける一般的なルーター
    @router = new App.Router()
    #@router.add('/', (params)-> new App.Cassette(App.PortalContext, params))
    @router.add('/', (params)-> new App.Cassette(App.PortalContext, params))
    @router.add('/q', (params)-> new App.Cassette(App.Q.IndexContext, params))
    @router.add('/q/tagged/:tags', (params)-> new App.Cassette(App.Q.IndexContext, params))
    @router.add('/q/:id', (params)-> new App.Cassette(App.Q.QuestionContext, params))

  _initializeScene: ->
    @content.pushContext(@_detectCassette().forPusher()...)

  _initializeValuables: ->

  #
  # History Manager
  #
  _backward: (e)=>
    @content.pushContext(@_detectCassette().forPusher()...)

  _forward: (e)=>
    @content.pushContext(@_detectCassette().forPusher()...)

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

  _choppedPath: ->
    location.href.replace(/.+?:\/\/(.+?)\//, '/').replace(/\?.*/, '')

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
    history.pushState({}, null, linker.uri)
    @content.pushContext(@_detectCassette().forPusher()...).then =>
      MathJax.Hub.Typeset()


