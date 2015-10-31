module.exports = FreeText = React.createClass(
  mixins: [Arda.mixin]

  render: ()->
    App.JSX.Q.freeText(
      Fa: App.View.Fa

      options: @props.options

      isMarked: => @props.result?
      input: (e)=>
        @dispatch('question:answer', e.target.value)
    )
)
