#
#
module.exports = class QuestionContext extends App.BaseContext
  component: React.createClass (
    mixins: [Arda.mixin]

    render: ->
      return React.createElement('div', {}) if @props.state == App.QuestionState.LOADING
      App.JSX.Q.question(
        Fa: App.View.Fa
        SingleChoice: App.View.SingleChoice
        MultipleChoices: App.View.MultipleChoices
        FreeText: App.View.FreeText
        Ox: App.View.Ox
        InOrder: App.View.InOrder
        QuestionState: App.QuestionState

        state: @props.state
        question: @props.question
        answers: @props.answers
        result: @props.result

        submit: =>
          @dispatch('question:submit')
      )

    componentDidMount: ->
    componentDidUpdate: -> @dispatch('inform:rendered')
  )

  initState: (props) ->
    id: props.id
    question: null
    answers: null
    state: App.QuestionState.LOADING
    result: null

  expandComponentProps: (props, state) ->
    state

  isAnswerable: ->
    @state.state == App.QuestionState.ASKING || @state.state == App.QuestionState.ASKED

  isSubmittable: ->
    @state.state == App.QuestionState.ASKED

  isInOrder: ->
    @state.question.isInOrder()

  isAnswersFullFilled: ->
    if @isInOrder()
      !_.include(@state.answers, '') && !_.include(@state.answers, null) && !_.include(@state.answers, undefined)
    else
      !_.isNull(@state.answers) && (@state.answers.length > 0 || _.isNumber(@state.answers))

  delegate: (subscribe) ->
    super
    subscribe 'context:started', -> @_initializeQuestion()
    subscribe 'question:show', (q)-> @root.emit('question:show', q)
    subscribe 'question:answer', (answer)->
      return unless @isAnswerable()
      @update (s) ->
        # _.mergeは内部の配列もmergeで処理してしまうため
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
        @update (s) -> _.merge(s,
          result: new App.Mark(data, s.question.options)
          state: App.QuestionState.MARKED
        )

  _initializeQuestion: ->
    @strikeApi(App.Linker.get(App.Path.q, id: @props.id)).then (data)=>
      @update (s) -> _.merge(s,
        question: new App.Question(data)
        state: App.QuestionState.ASKING
      )
      .then =>
        if @isInOrder()
          @update (s) -> _.merge(s, answers: new Array(s.question.answersNumber))

