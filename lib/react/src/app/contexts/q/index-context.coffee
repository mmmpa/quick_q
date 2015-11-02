#
#
module.exports = class IndexContext extends App.BaseContext
  initState: (props) ->
    index: []
    header: {}

  expandComponentProps: (props, state) ->
    state

  component: React.createClass (
    mixins: [Arda.mixin]

    render: ->
      console.log @props
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

  paginate: (page)->
    linker = App.Linker.get(App.Path.qIndex, page: page)
    @strikeApi(linker).then (data)=>
      @update (s) =>
        index: data.body
        header: data.header
    .then =>
      @root.emit('history:push', linker)

  _initializeIndex: ->
    @strikeApi(App.Linker.get(@_strippedPath())).then (data)=>
      @update (s) =>
        index: data.body
        header: data.header
