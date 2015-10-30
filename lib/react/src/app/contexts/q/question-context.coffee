#
#
module.exports = class QuestionContext extends App.BaseContext
  component: React.createClass (
    mixins: [Arda.mixin]

    render: ->
      return React.createElement('div', {}) unless @props?.question
      App.JSX.Q.question(
        question: @props.question
        answers: @props.answers
        Fa: App.View.Fa
        SingleChoice: App.View.SingleChoice
        is_active: => 'disabled' unless @props.answers
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

  expandComponentProps: (props, state) ->
    state

  delegate: (subscribe) ->
    super
    subscribe 'context:started', -> @_initializeQuestion()
    subscribe 'question:show', (q)-> @root.emit('question:show', q)
    subscribe 'question:answer', (answer)->
      @update (s) -> _.merge(s, answers: answer)

    subscribe 'question:submit', ->
      @strikeApi(App.Linker.post(App.Path.mark, id: @state.question.id, answers: @state.answers)).then (data)=>
        console.log data

  _initializeQuestion: ->
    @strikeApi(App.Linker.get(App.Path.q, id: @props.id)).then (data)=>
      @update (s) -> _.merge(s, question: new App.Question(data))
