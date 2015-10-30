module.exports = FreeText = React.createClass(
  mixins: [Arda.mixin]

  render: ()->
    App.JSX.Q.freeText(
      options: @props.options
      Fa: App.View.Fa
      is_active: (id)=> @props.answers == id
      is_marked: => @props.result?
      is_correct: (id)=> @props.result.answers[0] == id
      toggle: (index)=>
        @dispatch('question:answer', index)
    )
)
