jsdom = require 'jsdom'
global.navigator = { userAgent: 'node.js' }
global.document = jsdom.jsdom('<!doctype html><html><p id="main"></p><article id="app"></article></html>')
global.window = document.defaultView

config = require '../../helper'
assert = require 'power-assert'

require config.path('app', 'app')
TestUtils = require 'react-addons-test-utils'
Question = require config.path('model', 'question')
MainContext = require config.path('app', 'contexts/main-context')
BlankContext = require config.path('app', 'contexts/blank-context')
QuestionContext = require config.path('app', 'contexts/q/question-context')

describe 'Question', ->
  describe 'Base', ->
    it 'attributes', ->
      main = new MainContext(React.render(React.createElement(Arda.DefaultLayout, {}), document.getElementById('app')), {})
      main.emit 'context:created'
      main.emit 'context:started'
      main.lifecycle = 'active'
      q = new QuestionContext(React.render(React.createElement(Arda.DefaultLayout, {}), document.getElementById('app')), {})
      q.emit 'context:created'
      q.emit 'context:started'
      q.lifecycle = 'active'
      console.log q

