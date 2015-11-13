config = require '../helper'
assert = require 'power-assert'
Question = require config.path('model', 'question')
Mark = require config.path('model', 'mark')

describe 'Mark', ->
  before ->
    @q = new Question(
      id: 1
      options: [
        {
          id: 1
          text: '## 選択肢\n'
        }
      ]
    )

    @q2 = new Question(
      id: 1
      options: [
        {
          id: 1
          text: '## 選択肢a\n'
        }
        {
          id: 2
          text: '## 選択肢b\n'
        }
        {
          id: 3
          text: '## 選択肢c\n'
        }
      ]
    )

  describe 'Base', ->
    it 'attributes', ->
      mark = new Mark({mark: true, correct_answer: '正答'}, [])
      assert.equal mark.resultText, '正解!!'
      assert.deepEqual mark.answers, ['正答']
      assert.deepEqual mark.correctAnswer, __html: '正答'

    it 'attributes', ->
      mark = new Mark({mark: false, correct_answer: '正答'}, [])
      assert.equal mark.resultText, '不正解'
      assert.deepEqual mark.answers, ['正答']
      assert.deepEqual mark.correctAnswer, __html: '正答'

    it 'attributes', ->
      mark = new Mark({mark: true, correct_answer: 1}, @q.options)
      assert.equal mark.resultText, '正解!!'
      assert.deepEqual mark.answers, [1]
      assert.deepEqual mark.correctAnswer, __html: '<h2 id="-">選択肢</h2>\n'

    it 'attributes', ->
      mark = new Mark({mark: true, correct_answer: [1, 3]}, @q2.options)
      assert.equal mark.resultText, '正解!!'
      assert.deepEqual mark.answers, [1, 3]
      assert.deepEqual mark.correctAnswer, __html: '<h2 id="-a">選択肢a</h2>\n<br>\n\n<h2 id="-c">選択肢c</h2>\n'
