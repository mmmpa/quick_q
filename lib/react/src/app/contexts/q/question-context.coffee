#
#
module.exports = class QuestionContext extends App.BaseContext
  component: React.createClass (
    mixins: [Arda.mixin]

    render: ->
      console.log @props
      return React.createElement('div', {}) if @props.state == App.QuestionState.LOADING
      App.JSX.Q.question(
        state: @props.state
        QuestionState: App.QuestionState
        question: @props.question
        answers: @props.answers
        Fa: App.View.Fa
        SingleChoice: App.View.SingleChoice
        result: @props.result
        submit: =>
          return unless @props.answers
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
        _.merge(s, answers: answer)

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
