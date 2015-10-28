module.exports = Qqa = React.createClass (
  mixins: [Arda.mixin]
  render: ->
    App.JSX.Q.qIndex(

    )

  componentDidMount: ->
    console.log 'qqa mounted'
    childRouter = new Arda.Router(Arda.DefaultLayout, React.findDOMNode(@refs.content))
    @dispatch 'body:inited', childRouter
)
