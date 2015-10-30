#
#
module.exports = class QuestionContext extends App.BaseContext
  component: React.createClass (
    mixins: [Arda.mixin]

    render: ->
      console.log @props
      return React.createElement('div', {}) if @props.state == App.QuestionState.LOADING
      App.JSX.Q.question(
        Fa: App.View.Fa
        SingleChoice: App.View.SingleChoice
        MultipleChoices: App.View.MultipleChoices
        FreeText: App.View.FreeText
        Ox: App.View.Ox
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

  is_answerable: ->
    @state.state == App.QuestionState.ASKING || @state.state == App.QuestionState.ASKED

  is_submittable: ->
    @state.state == App.QuestionState.ASKED

  delegate: (subscribe) ->
    super
    subscribe 'context:started', -> @_initializeQuestion()
    subscribe 'question:show', (q)-> @root.emit('question:show', q)
    subscribe 'question:answer', (answer)->
      return unless @is_answerable()
      @update (s) ->
        if s.state == App.QuestionState.ASKING
          s.state = App.QuestionState.ASKED
        # _.mergeは内部の配列もmergeで処理してしまうため
        s.answers = answer
        s

    subscribe 'question:submit', ->
      return unless @is_submittable()
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
