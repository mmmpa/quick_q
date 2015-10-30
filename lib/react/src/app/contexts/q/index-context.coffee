#
#
module.exports = class IndexContext extends App.BaseContext
  initState: (props) ->
    { index: [] }

  expandComponentProps: (props, state) ->
    state

  component: React.createClass (
    mixins: [Arda.mixin]

    render: ->
      console.log @props
      App.JSX.Q.indexPage(
        index: (for q in @props.index
          new App.Question(q)
        )
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

  _initializeIndex: ->
    @strikeApi(App.Linker.get(App.Path.qIndex, par: 100)).then (data)=>
      console.log data
      @update (s) =>
        index: data
