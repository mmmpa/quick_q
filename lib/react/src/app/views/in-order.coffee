module.exports = SingleChoice = React.createClass(
  mixins: [Arda.mixin]

  render: ()->
    App.JSX.Q.inOrder(
      options: @props.options
      Fa: App.View.Fa
      is_active: (id)=> @props.answers == id
      is_marked: => @props.result?
      is_correct: (id)=> @props.result.answers[0] == id
      select: (e)=>
        new_answers = @props.answers?.concat() || []
        new_answers[e.target.name] = e.target.value
        @dispatch('question:answer', new_answers)
    )
)

