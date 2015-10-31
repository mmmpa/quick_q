jsdom = require 'jsdom'
global.navigator = { userAgent: 'node.js' }
global.document = jsdom.jsdom('<!doctype html><html><p id="main"></p><article id="app"></article></html>')
global.window = document.defaultView

config = require '../../helper'
assert = require 'power-assert'

require config.path('app', 'app')
DummyContext = require config.path('support', 'dummy-context')
QuestionContext = require config.path('app', 'contexts/q/question-context')

ArdaDefault = React.render(React.createElement(Arda.DefaultLayout, {}), document.getElementById('app'))

describe 'QuestionContext', ->
  describe 'State', ->
    it 'Single choice', ->
      DummyContext.struck = config.params.singleChoice
      q = new QuestionContext(ArdaDefault, { root: DummyContext, id: 1 })
      q.emit 'context:created'
      q.emit 'context:started'
      q.lifecycle = 'active'

      q._initByProps({ id: 1 })
      .then =>
        q.expandComponentProps(q.props, q.state)
        assert.equal q.isAnswerable(), false
        assert.equal q.isSubmittable(), false
        q._initializeQuestion()
      .then =>
        assert.equal q.isAnswerable(), true
        assert.equal q.isSubmittable(), false
        q._events['question:answer'].bind(q)(1)
      .then =>
        assert.equal q.state.state, 'asked'
        assert.equal q.isAnswerable(), true
        assert.equal q.isSubmittable(), true
        DummyContext.struck = {mark: true, correct_answer: 1}
        q._events['question:submit'].bind(q)()
      .then =>
        assert.equal q.isAnswerable(), false
        assert.equal q.isSubmittable(), false

    it 'Multiple choices', ->
      DummyContext.struck = config.params.multipleChoices
      q = new QuestionContext(ArdaDefault, { root: DummyContext, id: 1 })
      q.emit 'context:created'
      q.emit 'context:started'
      q.lifecycle = 'active'


      q._initByProps({ id: 1 })
      .then =>
        q.expandComponentProps(q.props, q.state)
        assert.equal q.isAnswerable(), false
        assert.equal q.isSubmittable(), false
        q._initializeQuestion()
      .then =>
        assert.equal q.isAnswerable(), true
        assert.equal q.isSubmittable(), false
        q._events['question:answer'].bind(q)([1])
      .then =>
        assert.equal q.isAnswerable(), true
        assert.equal q.isSubmittable(), true
        q._events['question:answer'].bind(q)([])
      .then =>
        assert.equal q.isAnswerable(), true
        assert.equal q.isSubmittable(), false
        q._events['question:answer'].bind(q)([1, 2])
      .then =>
        assert.equal q.state.state, 'asked'
        assert.equal q.isAnswerable(), true
        assert.equal q.isSubmittable(), true
        DummyContext.struck = {mark: true, correct_answer: [1, 2]}
        q._events['question:submit'].bind(q)()
      .then =>
        assert.equal q.isAnswerable(), false
        assert.equal q.isSubmittable(), false

    it 'In Order', ->
      DummyContext.struck = config.params.inOrder
      q = new QuestionContext(ArdaDefault, { root: DummyContext, id: 1 })
      q.emit 'context:created'
      q.emit 'context:started'
      q.lifecycle = 'active'

      q._initByProps({ id: 1 })
      .then =>
        q.expandComponentProps(q.props, q.state)
        assert.equal q.isAnswerable(), false
        assert.equal q.isSubmittable(), false
        q._initializeQuestion()
      .then =>
        assert.equal q.isAnswerable(), true
        assert.equal q.isSubmittable(), false
        assert.equal q.state.answers.length, config.params.inOrder.answers_number
        q._events['question:answer'].bind(q)([1, 2, 1, 2, 1])
      .then =>
        assert.equal q.isAnswerable(), true
        assert.equal q.isSubmittable(), true
        q._events['question:answer'].bind(q)([1, 2, null, 2, 3])
      .then =>
        assert.equal q.isAnswerable(), true
        assert.equal q.isSubmittable(), false
        q._events['question:answer'].bind(q)([1, 2, 1, 2, 1])
      .then =>
        assert.equal q.state.state, 'asked'
        assert.equal q.isAnswerable(), true
        assert.equal q.isSubmittable(), true
        DummyContext.struck = {mark: true, correct_answer: [1, 2, 1, 2, 1]}
        q._events['question:submit'].bind(q)()
      .then =>
        assert.equal q.isAnswerable(), false
        assert.equal q.isSubmittable(), false

    it 'Free text', ->
      DummyContext.struck = config.params.freeText
      q = new QuestionContext(ArdaDefault, { root: DummyContext, id: 1 })
      q.emit 'context:created'
      q.emit 'context:started'
      q.lifecycle = 'active'


      q._initByProps({ id: 1 })
      .then =>
        q.expandComponentProps(q.props, q.state)
        assert.equal q.isAnswerable(), false
        assert.equal q.isSubmittable(), false
        q._initializeQuestion()
      .then =>
        assert.equal q.isAnswerable(), true
        assert.equal q.isSubmittable(), false
        q._events['question:answer'].bind(q)('a')
      .then =>
        assert.equal q.isAnswerable(), true
        assert.equal q.isSubmittable(), true
        q._events['question:answer'].bind(q)('')
      .then =>
        assert.equal q.isAnswerable(), true
        assert.equal q.isSubmittable(), false
        q._events['question:answer'].bind(q)('a')
      .then =>
        assert.equal q.state.state, 'asked'
        assert.equal q.isAnswerable(), true
        assert.equal q.isSubmittable(), true
        DummyContext.struck = {mark: true, correct_answer: 'a'}
        q._events['question:submit'].bind(q)()
      .then =>
        assert.equal q.isAnswerable(), false
        assert.equal q.isSubmittable(), false

    it 'ox', ->
      DummyContext.struck = config.params.ox
      q = new QuestionContext(ArdaDefault, { root: DummyContext, id: 1 })
      q.emit 'context:created'
      q.emit 'context:started'
      q.lifecycle = 'active'


      q._initByProps({ id: 1 })
      .then =>
        q.expandComponentProps(q.props, q.state)
        assert.equal q.isAnswerable(), false
        assert.equal q.isSubmittable(), false
        q._initializeQuestion()
      .then =>
        assert.equal q.isAnswerable(), true
        assert.equal q.isSubmittable(), false
        q._events['question:answer'].bind(q)(1)
      .then =>
        assert.equal q.isAnswerable(), true
        assert.equal q.isSubmittable(), true
        q._events['question:answer'].bind(q)('')
      .then =>
        assert.equal q.isAnswerable(), true
        assert.equal q.isSubmittable(), false
        q._events['question:answer'].bind(q)(0)
      .then =>
        assert.equal q.state.state, 'asked'
        assert.equal q.isAnswerable(), true
        assert.equal q.isSubmittable(), true
        DummyContext.struck = {mark: true, correct_answer: 1}
        q._events['question:submit'].bind(q)()
      .then =>
        assert.equal q.isAnswerable(), false
        assert.equal q.isSubmittable(), false





