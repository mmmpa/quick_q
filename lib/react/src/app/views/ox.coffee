module.exports = Ox = React.createClass(
  mixins: [Arda.mixin]

  render: ()->
    App.JSX.Q.ox(
      Fa: App.View.Fa

      options: @props.options

      isFalse: => 'active' if @props.answers == 0
      isTrue: => 'active' if @props.answers == 1
      isMarked: => @props.result?
      toggle: (boolean)=>
        @dispatch('question:answer', boolean, @props.question.index)
    )
)
