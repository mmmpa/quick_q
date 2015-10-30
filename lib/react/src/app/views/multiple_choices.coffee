module.exports = SingleChoice = React.createClass(
  mixins: [Arda.mixin]

  render: ()->
    console.log @props.answers
    App.JSX.Q.singleChoice(
      options: @props.options
      Fa: App.View.Fa
      is_active: (id)=> _.include(@props.answers, id)
      is_marked: => @props.result?
      is_correct: (id)=> _.include(@props.result.answers, id)
      toggle: (id)=>
        new_answers = @props.answers?.concat() || []
        if _.include(new_answers, id)
          new_answers = _.reject(new_answers, (n)-> n == id)
        else
          new_answers.push(id)

        @dispatch('question:answer', new_answers)
    )
)
