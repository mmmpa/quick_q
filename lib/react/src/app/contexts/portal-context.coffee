#
#
#
module.exports = class BlankContext extends App.BaseContext
  component: Portal = React.createClass (
    mixins: [Arda.mixin]

    render: ->
      App.JSX.portal()

    componentDidMount: ->
      console.log @
  )

  initState: (props) -> props
