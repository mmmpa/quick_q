config = require '../../helper'
assert = require 'power-assert'

click = document.createEvent("HTMLEvents")
click.initEvent("click", false, true)

require config.path('app', 'app')
DummyContext = require config.path('support', 'dummy-context')
GlobalContext = require config.path('app', 'contexts/menu/global-context')

ArdaDefault = ReactDOM.render(React.createElement(Arda.DefaultLayout, {}), document.getElementById('app'))

describe 'GlobalContext', ->
  describe 'HTML Rendering', ->
    it 'Common parts', ->
      DummyContext.struck = config.params.singleChoice
      c = new GlobalContext(ArdaDefault, { root: DummyContext, id: 1 })
      c.emit 'context:created'
      c.emit 'context:started'
      c.lifecycle = 'active'

      c._initByProps(templateProps: {})
      .then =>
        c.expandComponentProps(c.props, c.state)
      .then =>
        c.update((s)-> s)
      .then =>
        $('button.global-menu.go-home').trigger('click')
        assert.deepEqual DummyContext.params, ['app:home']
