#
#
module.exports = class IndexContext extends App.BaseContext
  initState: (props) ->
    index: []
    header: {}
    qTags: []
    tagSelectorState: App.TagSelectorState.LOADING
    selectorOpened: false
    selectedTags: if !props.tags
      []
    else
      _.map(@props.tags.split(','), (n)=> +n)
    basePath: ''

  expandComponentProps: (props, state) ->
    state

  component: React.createClass (
    mixins: [Arda.mixin]

    getInitialState: ->
      old: null

    render: ->
      App.JSX.Q.indexPage(
        Paginator: App.View.Paginator
        TagSelector: App.View.TagSelector
        Loading: App.View.Loading
        index: (for q in @props.index
          new App.Question(q)
        )
        header: @props.header
        selectedTags: @props.selectedTags
        tagSelectorState: @props.tagSelectorState
        selectorOpened: @props.selectorOpened
        qTags: (for tag in @props.qTags
          new App.Tag(tag)
        )
        showQuestion: (e)=>
          @dispatch('question:show', e)
      )

    componentDidUpdate: ->
      if @state.old != @props.index
        @dispatch('inform:rendered')
        @state.old = @props.index
  )

  delegate: (subscribe) ->
    super
    #@_initializeIndex()
    subscribe 'context:started', -> @_initializeIndex()
    subscribe 'question:show', (q)-> @root.emit('question:show', q)
    subscribe 'question:index:paginate', @paginate
    subscribe 'question:tag:toggle', @toggleTag
    subscribe 'question:tagSelector:toggle', ->
      @update (s) ->
        s.selectorOpened = !s.selectorOpened
        s

  generateId: ->
    @id ?= 0
    @id++
    @id

  currentId: ->
    @id ?= 0

  generateTagId: ->
    @tagId ?= 0
    @tagId++
    @tagId

  currentTagId: ->
    @tagId ?= 0

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

    tags = _.sortBy(tags)

    linker = App.Linker.get(App.Path.taggedIndex, tags: tags.join(','))

    myId = @generateTagId()
    @generateId()
    @update (s) =>
      s.tagSelectorState = App.TagSelectorState.TOGGLED
      s.selectedTags = tags
      s.index = []
      s
    @strikeApi(linker).then (data)=>
      throw 'older' if myId != @currentTagId()
      @update (s) =>
        s.index = data.body
        s.header = data.header
        s
    .then =>
      @root.emit('history:push', linker)
      @update (s) =>
        s.basePath = @_choppedPath()
        s
    .then =>
      @update (s) =>
        s.tagSelectorState = App.TagSelectorState.LOADING
        s
    .then =>
      @strikeApi(App.Linker.get(App.Path.taggedTags, tags: tags)).then (data)=>
        @update (s) =>
          s.tagSelectorState = App.TagSelectorState.LOADED
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
    @strikeApi(App.Linker.get(App.Path.taggedTags, tags: @state.selectedTags)).then (data)=>
      @update (s) =>
        s.tagSelectorState = App.TagSelectorState.LOADED
        s.qTags = data.body
        s
