#
#
#
module.exports = class BlankContext extends App.BaseContext
  component: Portal = React.createClass (
    mixins: [Arda.mixin]

    render: ->
      App.JSX.portal(
        Fa: App.View.Fa
        Loading: App.View.Loading
        qTags: (for q in @props.tags
          new App.Tag(q)
        )
        sources: @props.sources
        showTaggedIndex: (id)=>
          @dispatch('question:tagged:index', id)
        isSourcesLoaded: => @props.sources.length != 0
        isTagsLoaded: => @props.tags.length != 0
      )
  )

  initState: (props) ->
    tags: []
    sources: []

  expandComponentProps: (props, state) ->
    state

  delegate: (subscribe) ->
    super
    #@_initializeIndex()
    subscribe 'context:started', -> @_initializeTags()
    subscribe 'context:started', -> @_initializeSources()
    subscribe 'question:show', (q)-> @root.emit('question:show', q)
    subscribe 'question:tagged:index', (id)-> @root.emit('question:tagged:index', [id])

  _initializeTags: ->
    @strikeApi(App.Linker.get(App.Path.tags)).then (data)=>
      @update (s) => _.merge(s, tags: data.body)

  _initializeSources: ->
    @strikeApi(App.Linker.get(App.Path.sources)).then (data)=>
      @update (s) => _.merge(s, sources: data.body)
