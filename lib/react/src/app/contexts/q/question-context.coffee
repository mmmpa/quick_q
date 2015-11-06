#
#
module.exports = class QuestionContext extends App.BaseContext
  component: React.createClass (
    mixins: [Arda.mixin]

    getInitialState: ->
      informed: false

    render: ->
      return App.JSX.loading(Fa: App.View.Fa) if @props.state == App.QuestionState.LOADING

      App.JSX.Q.question(
        Fa: App.View.Fa
        AnswerOption: @detectAnswerOption()
        InOrder: App.View.InOrder
        QuestionState: App.QuestionState
        Loading: App.View.Loading
        sourceLink: @props.sourceLink
        state: @props.state
        question: @props.question
        answers: @props.answers
        result: @props.result
        qTags: @props.qTags
        submit: =>
          @dispatch('question:submit')
        showTaggedIndex: (id)=>
          @dispatch('question:tagged:index', id)
        goBack: =>
          if @hasHistory()
            history.back()
          else
            @dispatch('app:home')
        isCorrect: =>
          if @props.result.isCorrect
            @props.result.isCorrect()
          else
            @props.result[0].isCorrect()
        resultText: =>
          if @props.result.resultText
            @props.result.resultText
          else
            @props.result[0].resultText
      )

    componentDidUpdate: ->
      unless @state.informed && @props.question
        @dispatch('inform:rendered')
        @state.informed = true

    hasHistory: ->
      window.history.state && window.history.state.historyWardUID

    detectAnswerOption: ->
      q = @props.question
      switch
        when q.isFreeText()
          App.View.FreeText
        when q.isOx()
          App.View.Ox
        when q.isSingleChoice()
          App.View.SingleChoice
        when q.isMultipleChoices()
          App.View.MultipleChoices
        when q.isInOrder()
          App.View.InOrder
        when q.isMultipleQuestions()
          App.View.MultipleQuestions
  )

  initState: (props) ->
    id: props.id
    question: null
    answers: null
    state: App.QuestionState.LOADING
    result: null
    sourceLink: null
    qTags: null

  expandComponentProps: (props, state) ->
    state

  isAnswerable: ->
    @state.state == App.QuestionState.ASKING || @state.state == App.QuestionState.ASKED

  isSubmittable: ->
    @state.state == App.QuestionState.ASKED

  isInOrder: ->
    @state.question.isInOrder()

  isMultipleQuestions: ->
    @state.question.isMultipleQuestions()

  isAnswersFullFilled: ->
    if @isMultipleQuestions()
      result = true
      _.each(_.zip(@state.question.children, @state.answers), (qa)=>
        [q, a] = qa
        result = false unless @isAnswersFullFilledOf(q, a || '')
      )
      result
    else
      @isAnswersFullFilledOf(@state.question, @state.answers)


  isAnswersFullFilledOf: (q, a)->
    if q.isInOrder()
      !_.include(a, '') && !_.include(a, null) && !_.include(a, undefined)
    else
      !_.isNull(a) && (a.length > 0 || _.isNumber(a))

  delegate: (subscribe) ->
    super
    subscribe 'context:started', -> @_initializeQuestion()
    subscribe 'question:show', (q)-> @root.emit('question:show', q)
    subscribe 'question:answer', (answer, index)->
      return unless @isAnswerable()
      @update (s) ->
        # _.mergeは内部の配列もmergeで処理してしまうため
        if @isMultipleQuestions()
          s.answers ?= []
          s.answers[+index] = answer
        else
          s.answers = answer
        s
      .then =>
        if @isAnswersFullFilled()
          @update (s) -> _.merge(s, state: App.QuestionState.ASKED)
        else
          @update (s) -> _.merge(s, state: App.QuestionState.ASKING)

    subscribe 'question:submit', ->
      return unless @isSubmittable()
      @update (s) -> _.merge(s, state: App.QuestionState.SUBMITTING)
      @strikeApi(App.Linker.post(App.Path.mark, id: @state.question.id, answers: @state.answers)).then (data)=>
        if @isMultipleQuestions()
          subMarks = _.map(data.body.correct_answer, (mark, index)=>
            subMark = _.clone(data.body)
            subMark.correct_answer = mark
            new App.Mark(subMark, @state.question.children[index].options)
          )
          @update (s) ->
            s.result = subMarks
            s.state = App.QuestionState.MARKED
            s
        else
          @update (s) -> _.merge(s,
            result: new App.Mark(data.body, s.question.options)
            state: App.QuestionState.MARKED
          )
    subscribe 'question:tagged:index', (id)-> @root.emit('question:tagged:index', [id])
    subscribe 'app:home', -> @root.emit('app:home')

  _initializeQuestion: ->
    @strikeApi(App.Linker.get(App.Path.q, id: @props.id)).then (data)=>
      @update (s) -> _.merge(s,
        question: new App.Question(data.body)
        state: App.QuestionState.ASKING
      )
      .then =>
        if @isInOrder()
          @update (s) -> _.merge(s, answers: new Array(s.question.answersNumber))
      .then =>
        if @state.question.hasSource
          @strikeApi(App.Linker.get(App.Path.source, id: @state.question.sourceLinkId)).then (data)=>
            @update (s) ->
              s.sourceLink = new App.SourceLink(data.body)
              s
          @strikeApi(App.Linker.get(App.Path.qTags, id: @props.id)).then (data)=>
            @update (s) ->
              s.qTags = _.map(data.body, (tag)=>
                new App.Tag(tag)
              )
              s

