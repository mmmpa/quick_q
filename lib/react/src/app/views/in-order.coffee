module.exports = SingleChoice = React.createClass(
  mixins: [Arda.mixin]

  render: ()->
    q = @props.question
    App.JSX.Q.inOrder(
      Fa: App.View.Fa

      options: q.options
      answersNumber:q.answersNumber

      isActive: (id)=> @props.answers == id
      isMarked: => @props.result?
      isCorrect: (index, id)=> +@props.answers[index] == @props.result.answers[index]
      select: (e)=>
        new_answers = @props.answers?.concat() || []
        new_answers[e.target.name] = e.target.value
        @dispatch('question:answer', new_answers)
    )
)

