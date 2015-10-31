module.exports = SingleChoice = React.createClass(
  mixins: [Arda.mixin]

  render: ()->
    App.JSX.Q.singleChoice(
      Fa: App.View.Fa
      options: @props.options

      isActive: (id)=> _.include(@props.answers, id)
      isMarked: => @props.result?
      isCorrect: (id)=> _.include(@props.result.answers, id)
      toggle: (id)=>
        new_answers = @props.answers?.concat() || []
        if _.include(new_answers, id)
          new_answers = _.reject(new_answers, (n)-> n == id)
        else
          new_answers.push(id)
        @dispatch('question:answer', new_answers)
    )
)
