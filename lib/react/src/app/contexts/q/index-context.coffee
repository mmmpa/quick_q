#
#
module.exports = class IndexContext extends App.BaseContext
  initState: (props) ->
    index: []
    header: {}
    qTags: []
    selectorOpened: false
    selectedTags: if !@props.tags
      []
    else
      _.map(@props.tags.split(','), (n)=> +n)
    basePath: ''

  expandComponentProps: (props, state) ->
    state

  component: React.createClass (
    mixins: [Arda.mixin]

    render: ->
      return App.JSX.loading(Fa: App.View.Fa) if @props.index.length == 0
      App.JSX.Q.indexPage(
        Paginator: App.View.Paginator
        TagSelector: App.View.TagSelector
        index: (for q in @props.index
          new App.Question(q)
        )
        header: @props.header
        selectedTags: @props.selectedTags
        selectorOpened: @props.selectorOpened
        qTags: (for tag in @props.qTags
          new App.Tag(tag)
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
    subscribe 'question:index:paginate', @paginate
    subscribe 'question:tag:toggle', @toggleTag

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
        s.index = data.body
        s.header = data.header
        s
    .then =>
      @root.emit('history:push', linker)
      @root.emit('window:top')

  toggleTag: (id)=>
    tags = if _.include(@state.selectedTags, id)
      _.remove(@state.selectedTags.concat(), (n)=> n != id)
    else
      newTags = @state.selectedTags.concat()
      newTags.push(id)
      newTags

    linker = App.Linker.get(App.Path.taggedIndex, tags: tags.join(','))

    myId = @generateId()
    @strikeApi(linker).then (data)=>
      #throw 'older' if myId != @currentId()
      @update (s) =>
        s.index = data.body
        s.header = data.header
        s.selectedTags = tags
        s
    .then =>
      @root.emit('history:push', linker)
      @update (s) =>
        s.basePath = @_choppedPath()
        s
    .then =>
      @strikeApi(App.Linker.get(App.Path.taggedTags, tags: tags)).then (data)=>
        @update (s) =>
          s.qTags = data.body
          s

  _initializeIndex: ->
    @strikeApi(App.Linker.get(@_strippedPath())).then (data)=>
      @update (s) =>
        s.basePath = @_choppedPath()
        s.index = data.body
        s.header = data.header
        s
      .then =>
        @_initializeTags()

  _initializeTags: ->
    @strikeApi(App.Linker.get(App.Path.taggedTags, tags: @props.tags)).then (data)=>
      @update (s) =>
        s.qTags = data.body
        s
