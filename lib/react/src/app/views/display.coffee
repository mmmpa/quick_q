module.exports = Display = React.createClass (
  mixins: [Arda.mixin]
  render: ->
    App.JSX.main()

  componentDidMount: ->
    routers = {
      content: new Arda.Router(Arda.DefaultLayout, React.findDOMNode(@refs.content))
      notifier: new Arda.Router(Arda.DefaultLayout, React.findDOMNode(@refs.notifier))
      menu: new Arda.Router(Arda.DefaultLayout, React.findDOMNode(@refs.menu))
    }
    console.log 'Display mounted', routers
    @dispatch 'display:initialized', routers
)
