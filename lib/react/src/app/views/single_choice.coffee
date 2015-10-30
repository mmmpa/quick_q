module.exports = SingleChoice = React.createClass(
  mixins: [Arda.mixin]

  render: ()->
    console.log @props
    App.JSX.Q.singleChoice(
      options: @props.options
      Fa: App.View.Fa
      is_active: (index)=> 'active' if @props.answers == index
      toggle: (index)=>
        @dispatch('question:answer', index)
    )
)
