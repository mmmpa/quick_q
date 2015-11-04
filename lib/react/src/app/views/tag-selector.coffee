module.exports = TagSelector = React.createClass(
  mixins: [Arda.mixin]

  getInitialState: ->
    opened: false

  render: ()->
    App.JSX.Q.tagSelector(
      Fa: App.View.Fa
      qTags: @props.qTags
      toggleTag: (id)=>
        @dispatch('question:tag:toggle', id)
      isChecked: (id)=>
        _.include(@props.selectedTags, id)
      isOpen: =>
        @state.opened
      openSelector: =>
        @setState(opened: true)
      closeSelector: =>
        @setState(opened: false)
    )
)
