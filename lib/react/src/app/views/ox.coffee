module.exports = Ox = React.createClass(
  mixins: [Arda.mixin]

  render: ()->
    App.JSX.Q.ox(
      options: @props.options
      Fa: App.View.Fa
      is_true: => 'active' if @props.answers == 1
      is_false: => 'active' if @props.answers == 0
      is_marked: => @props.result?
      toggle: (boolean)=>
        @dispatch('question:answer', boolean)
    )
)
