config = require '../helper'
assert = require 'power-assert'
Question = require config.path('model', 'question')


describe 'Question', ->
  describe 'Base', ->
    it 'attributes', ->
      q = new Question(
        id: 1
        text: '# 問題文'
        way: 'single_choice'
        options: [
          {
            id: 1
            text: '## 選択肢\n'
          }
        ]
      )
      assert.equal q.id, 1
      assert.equal q.text, '# 問題文'
      assert.deepEqual q.marked, __html: '<h1 id="-">問題文</h1>\n'
      assert.deepEqual q.options, [
        {
          id: 1
          marked:
            __html: '<h2 id="-">選択肢</h2>\n'
        }
      ]

    it 'auto insert blank to null attributes', ->
      q = new Question(
        id: 1
      )
      assert.deepEqual q.options, []
      assert.equal q.answersNumber, -1
      assert.equal q.text, ''
      assert.equal q.way, ''

  describe 'Each way', ->
    before ->
      @base = {
        id: 1
        text: '# 問題文'
        way: 'single_choice'
        options: [
          {
            id: 1
            text: '## 選択肢\n'
          }
        ]
      }

    it 'single choice', ->
      @base.way = 'single_choice'
      q = new Question(@base)
      assert.equal q.isSingleChoice(), true

    it 'multiple choices', ->
      @base.way = 'multiple_choices'
      q = new Question(@base)
      assert.equal q.isMultipleChoices(), true

    it 'free text', ->
      @base.way = 'free_text'
      q = new Question(@base)
      assert.equal q.isFreeText(), true

    it 'in_order', ->
      @base.way = 'in_order'
      q = new Question(@base)
      assert.equal q.isInOrder(), true

    it 'ox', ->
      @base.way = 'ox'
      q = new Question(@base)
      assert.equal q.isOx(), true

  describe 'trim', ->
    it 'html triming', ->
      assert.equal Question.trim('<h2 id="-">選択肢</h2>\n'), '選択肢\n'
