config = require '../../helper'
assert = require 'power-assert'

require config.path('app', 'app')
DummyContext = require config.path('support', 'dummy-context')
QuestionContext = require config.path('app', 'contexts/q/question-context')

ArdaDefault = React.render(React.createElement(Arda.DefaultLayout, {}), document.getElementById('app'))

describe 'QuestionContext', ->
  describe 'HTML Rendering', ->
    it 'Common parts', ->
      DummyContext.struck = config.params.singleChoice
      q = new QuestionContext(ArdaDefault, { root: DummyContext, id: 1 })
      q.emit 'context:created'
      q.emit 'context:started'
      q.lifecycle = 'active'

      q._initByProps({ id: 1 })
      .then =>
        q.expandComponentProps(q.props, q.state)
        q._initializeQuestion()
      .then =>
        assert.equal $('button.question-q.button.submit').prop('disabled'), true
        q._events['question:answer'].bind(q)(1)
      .then =>
        assert.equal $('button.question-q.button.submit').prop('disabled'), false
        DummyContext.struck = { mark: true, correct_answer: 1 }
        q._events['question:submit'].bind(q)(2)
      .then =>
        assert.equal $('section.question-q.control').length, 0
        assert.equal $('section.question-q.result-area').length, 1

    it 'Single choice', ->
      DummyContext.struck = config.params.singleChoice
      q = new QuestionContext(ArdaDefault, { root: DummyContext, id: 1 })
      q.emit 'context:created'
      q.emit 'context:started'
      q.lifecycle = 'active'

      q._initByProps({ id: 1 })
      .then =>
        q.expandComponentProps(q.props, q.state)
        q._initializeQuestion()
      .then =>
        assert.equal $('section.question-q.body').length, 1
        assert.equal $('li.question-q.option').length, 3
        assert.equal $('section.question-q.control').length, 1
        q._events['question:answer'].bind(q)(1)
      .then =>
        assert.equal $($('li.question-q.option')[0]).find('.active').length, 1
        assert.equal $('li.question-q.option').find('.active').length, 1
        q._events['question:answer'].bind(q)(2)
      .then =>
        assert.equal $($('li.question-q.option')[0]).find('.active').length, 0
        assert.equal $($('li.question-q.option')[1]).find('.active').length, 1
        assert.equal $('li.question-q.option').find('.active').length, 1
        DummyContext.struck = { mark: true, correct_answer: 1 }
        q._events['question:submit'].bind(q)(2)
      .then =>
        q._events['question:answer'].bind(q)(3)
      .then =>
        assert.equal $($('li.question-q.option')[0]).find('.active').length, 0
        assert.equal $($('li.question-q.option')[1]).find('.active').length, 1

    it 'Multiple choices', ->
      DummyContext.struck = config.params.multipleChoices
      q = new QuestionContext(ArdaDefault, { root: DummyContext, id: 1 })
      q.emit 'context:created'
      q.emit 'context:started'
      q.lifecycle = 'active'

      q._initByProps({ id: 1 })
      .then =>
        q.expandComponentProps(q.props, q.state)
        q._initializeQuestion()
      .then =>
        assert.equal $('section.question-q.body').length, 1
        assert.equal $('li.question-q.option').length, 3
        assert.equal $('section.question-q.control').length, 1
        q._events['question:answer'].bind(q)([1])
      .then =>
        assert.equal $($('li.question-q.option')[0]).find('.active').length, 1
        assert.equal $('li.question-q.option').find('.active').length, 1
        q._events['question:answer'].bind(q)([1, 2])
      .then =>
        assert.equal $($('li.question-q.option')[0]).find('.active').length, 1
        assert.equal $($('li.question-q.option')[1]).find('.active').length, 1
        assert.equal $('li.question-q.option').find('.active').length, 2
        DummyContext.struck = { mark: true, correct_answer: 1 }
        q._events['question:submit'].bind(q)(2)
      .then =>
        q._events['question:answer'].bind(q)([3])
      .then =>
        assert.equal $($('li.question-q.option')[0]).find('.active').length, 1
        assert.equal $($('li.question-q.option')[1]).find('.active').length, 1

    it 'In Order', ->
      DummyContext.struck = config.params.inOrder
      q = new QuestionContext(ArdaDefault, { root: DummyContext, id: 1 })
      q.emit 'context:created'
      q.emit 'context:started'
      q.lifecycle = 'active'

      q._initByProps({ id: 1 })
      .then =>
        q.expandComponentProps(q.props, q.state)
        q._initializeQuestion()
      .then =>
        assert.equal $('section.question-q.body').length, 1
        assert.equal $('select.question-q.order.selector').length, 5
        assert.equal $('section.question-q.control').length, 1
        q._events['question:answer'].bind(q)([1, 2, 2, 3, 3])
      .then =>
        assert.equal $('select.question-q.order.selector')[0].value, 1
        assert.equal $('select.question-q.order.selector')[1].value, 2
        assert.equal $('select.question-q.order.selector')[2].value, 2
        assert.equal $('select.question-q.order.selector')[3].value, 3
        assert.equal $('select.question-q.order.selector')[4].value, 3
        q._events['question:answer'].bind(q)([2, 1, null, 1, 1])
      .then =>
        assert.equal $('select.question-q.order.selector')[0].value, 2
        assert.equal $('select.question-q.order.selector')[1].value, 1
        assert.equal $('select.question-q.order.selector')[2].value, ''
        assert.equal $('select.question-q.order.selector')[3].value, 1
        assert.equal $('select.question-q.order.selector')[4].value, 1
        q._events['question:answer'].bind(q)([2, 1, 2, 1, 1])
      .then =>
        DummyContext.struck = { mark: true, correct_answer: 1 }
        q._events['question:submit'].bind(q)(2)
      .then =>
        assert.equal $('select.question-q.order.selector').prop('disabled'), true

    it 'ox', ->
      DummyContext.struck = config.params.ox
      q = new QuestionContext(ArdaDefault, { root: DummyContext, id: 1 })
      q.emit 'context:created'
      q.emit 'context:started'
      q.lifecycle = 'active'

      q._initByProps({ id: 1 })
      .then =>
        q.expandComponentProps(q.props, q.state)
        q._initializeQuestion()
      .then =>
        assert.equal $('section.question-q.body').length, 1
        assert.equal $('section.question-q.ox-control').length, 1
        assert.equal $('div.question-q.ox-button.active').length, 0
        assert.equal $('section.question-q.ox-control').length, 1
        assert.equal $('section.question-q.control').length, 1
        q._events['question:answer'].bind(q)(1)
      .then =>
        assert.equal $('div.question-q.ox-button.o.active').length, 1
        assert.equal $('div.question-q.ox-button.x.active').length, 0
        q._events['question:answer'].bind(q)(0)
      .then =>
        assert.equal $('div.question-q.ox-button.o.active').length, 0
        assert.equal $('div.question-q.ox-button.x.active').length, 1
        DummyContext.struck = { mark: true, correct_answer: 'o' }
        q._events['question:submit'].bind(q)(2)
      .then =>
        q._events['question:answer'].bind(q)(1)
        assert.equal $('div.question-q.ox-button.o.active').length, 0
        assert.equal $('div.question-q.ox-button.x.active').length, 1

    it 'Free text', ->
      DummyContext.struck = config.params.freeText
      q = new QuestionContext(ArdaDefault, { root: DummyContext, id: 1 })
      q.emit 'context:created'
      q.emit 'context:started'
      q.lifecycle = 'active'

      q._initByProps({ id: 1 })
      .then =>
        q.expandComponentProps(q.props, q.state)
        q._initializeQuestion()
      .then =>
        assert.equal $('section.question-q.body').length, 1
        assert.equal $('section.question-q.control').length, 1
        q._events['question:answer'].bind(q)('a')
      .then =>
        assert.equal $('input.question-q.free-text')[0].value, 'a'
        q._events['question:answer'].bind(q)('aa')
      .then =>
        assert.equal $('input.question-q.free-text').val(), 'aa'
        DummyContext.struck = { mark: true, correct_answer: 'ao' }
        q._events['question:submit'].bind(q)(2)
      .then =>
        assert.equal $('input.question-q.free-text').prop('disabled'), true

  describe 'State Transition', ->
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
        DummyContext.struck = { mark: true, correct_answer: 1 }
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
        DummyContext.struck = { mark: true, correct_answer: [1, 2] }
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
        DummyContext.struck = { mark: true, correct_answer: [1, 2, 1, 2, 1] }
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
        DummyContext.struck = { mark: true, correct_answer: 'a' }
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
        DummyContext.struck = { mark: true, correct_answer: 1 }
        q._events['question:submit'].bind(q)()
      .then =>
        assert.equal q.isAnswerable(), false
        assert.equal q.isSubmittable(), false
