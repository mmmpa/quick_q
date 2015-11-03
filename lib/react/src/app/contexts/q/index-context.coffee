#
#
module.exports = class IndexContext extends App.BaseContext
  initState: (props) ->
    index: []
    header: {}
    basePath: ''

  expandComponentProps: (props, state) ->
    state

  component: React.createClass (
    mixins: [Arda.mixin]

    render: ->
      return App.JSX.loading(Fa: App.View.Fa) if @props.index.length == 0
      App.JSX.Q.indexPage(
        Paginator: App.View.Paginator
        index: (for q in @props.index
          new App.Question(q)
        )
        header: @props.header
        showQuestion: (e)=>
          @dispatch('question:show', e)
      )

    componentDidMount: ->
    componentDidUpdate: -> @dispatch('inform:rendered')
  )

  delegate: (subscribe) ->
    super
    #@_initializeIndex()
    subscribe 'context:started', -> @_initializeIndex()
    subscribe 'question:show', (q)-> @root.emit('question:show', q)
    subscribe 'question:index:paginate', @paginate

  generateId: ->
    @id ?= 0
    @id++
    @id

  currentId: ->
    @id ?= 0

  paginate: (page)->
    linker = App.Linker.get(@state.basePath, page: page)
    myId = @generateId()
    @strikeApi(linker).then (data)=>
      throw 'older' if myId != @currentId()
      @update (s) =>
        basePath: @_choppedPath()
        index: data.body
        header: data.header
    .then =>
      @root.emit('history:push', linker)

  _initializeIndex: ->
    @strikeApi(App.Linker.get(@_strippedPath())).then (data)=>
      @update (s) =>
        basePath: @_choppedPath()
        index: data.body
        header: data.header
