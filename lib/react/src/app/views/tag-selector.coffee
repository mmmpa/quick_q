module.exports = TagSelector = React.createClass(
  mixins: [Arda.mixin]

  render: ()->
    App.JSX.Q.tagSelector(
      Fa: App.View.Fa
      qTags: @props.qTags
      Loading: App.View.Loading
      toggleTag: (id)=>
        @dispatch('question:tag:toggle', id)
      isChecked: (id)=>
        _.include(@props.selectedTags, id)
      isLocked: =>
        @props.tagSelectorState != App.TagSelectorState.LOADED
      isOpen: =>
        @props.selectorOpened
      openSelector: =>
        @dispatch('question:tagSelector:toggle')
      closeSelector: =>
        @dispatch('question:tagSelector:toggle')
    )
)

