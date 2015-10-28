module.exports = class MainContext extends Arda.Context
  _history = []
  _feature = []
  _now = 0

  component: App.View.Qqa

  initState: (props) -> props

  expandComponentProps: (props, state) -> props

  stripPath: (path)->
    (path || location.href).replace(/.+?:\/\/(.+?)\//, '/')

  detectComponent: (path)->
    detector = @stripPath(path) || ''
    switch
      when detector.match(/^\/accounts\/new/)?
        App.AccountContext
      when detector.match(/^\/accounts\/.+\/edit/)?
        App.AccountContext
      when detector.match(/^\/accounts.*/)?
        App.AccountIndexPageContext
      when detector.match(/^\/workbooks\/new/)?
        App.WorkbookEditContext
      when detector.match(/^\/workbooks$/)?, detector.match(/^\/workbooks\/index\/.*/)?
        App.WorkbookIndexContext
      when detector.match(/^\/workbooks\/.+\/question\/new/)?
        App.QuestionEditContext
      when detector.match(/^\/workbooks\/.+\/selectors\/.+/)?
        App.QuestionEditContext
      when detector.match(/^\/workbooks\/.+\/edit/)?
        App.WorkbookEditContext
      when detector.match(/^\/workbooks\/.+/)?
        App.WorkbookContext
      when detector.match(/^\/workbooks\/.+/)?
        App.WorkbookContext
      when detector.match(/^\/challenges\/(.+)\/review/)?
        challenge_key: RegExp.$1
        component: App.ChallengeReviewContext
      when detector.match(/^\/challenges\/(.+)\/([0-9]+)/)?
        challenge_key: RegExp.$1
        index: RegExp.$2
        component: App.ChallengeQuestionContext
      when detector.match(/^\/challenges\/(.+)/)?
        challenge_key: RegExp.$1
        component: App.ChallengeResultContext
      when detector == '/'
        App.PortalPageContext

  replaceScene: (body, header, path, historize = true) =>
    component = if _.isFunction(result = @detectComponent(path))
      params = {}
      result
    else
      params = result
      result.component

    console.log 'component', component, result

    return unless component

    passingBody = body || @props.config.body
    passingBody.params = params

    (if @router.history.length
      @router.replaceContext(component, passed =
          body: passingBody
          header: header || @props.config.header
          root: @
      )
    else
      @router.pushContext(component, passed =
          body: passingBody
          header: header || @props.config.header
          root: @
      )
    ).then =>
      if historize
        @pushHistory(body, header, path)
      window.scrollTo(null, 0)

  backward: (e)=>
    @.emit 'scene:change',
      path: location.href
      unhistorize: true

  forward: (e)=>
    @.emit 'scene:change',
      path: location.href
      unhistorize: true

  pickHeaderParameters: (xhr)->
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

  pushHistory: (body, header, path)->
    if fitstHistroy
      fitstHistroy = false
      return
    _history = _history[0.._now]
    _now = _history.length
    _history.push({ body: body, header: header, path: path })
    history.pushState({ position: _history.length - 1 }, null, path)

  initializeEventWatcher: ->
    HistoryWard.startBrutally()
    $(window).on(HistoryWard.BACKWARD, @backward)
    $(window).on(HistoryWard.FORWARD, @forward)

  delegate: (subscribe) ->
    super

    subscribe 'context:created', ->
      @initializeEventWatcher()
      #@onSceneChange(@props.config.body, @props.config.header, null, true)

    subscribe 'body:inited', (router)=>
      @router = router

    subscribe 'notify:success', (title, message)=>
      notifySuccess(title, message)

    subscribe 'notify:fail', (title, message)=>
      notifyDanger(title, message)

    subscribe 'reload', =>
      @update((state) => state)

    subscribe 'scene:change', (link)->
      {data, method} = if link.method?
        { data: { _method: link.method }, method: link.method }
      else
        { data: {}, method: 'get' }
      $.ajax {
        url: link.path + '.json',
        dataType: 'json',
        data: data
        type: method
      }
      .success (body, _, xhr) =>
        @replaceScene(body, @pickHeaderParameters(xhr), link.path, !link.unhistorize)
      .fail (data) ->
        console.error('error', link)

storedHistory = []
fitstHistroy = true



isCrossDomain = (url)->
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
