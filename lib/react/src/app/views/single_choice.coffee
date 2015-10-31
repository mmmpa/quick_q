module.exports = SingleChoice = React.createClass(
  mixins: [Arda.mixin]

  render: ()->
    App.JSX.Q.singleChoice(
      Fa: App.View.Fa

      options: @props.options

      isActive: (id)=> @props.answers == id
      isCorrect: (id)=> @props.result.answers[0] == id
      isMarked: => @props.result?
      toggle: (index)=>
        @dispatch('question:answer', index)
    )
)
