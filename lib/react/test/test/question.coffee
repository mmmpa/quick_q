config = require '../helper'
assert = require 'power-assert'
Question = require config.path('model', 'question')
App.Linker = require config.path('model', 'linker')
App.Path = require config.path('app', 'path')


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
      assert.notEqual q.pleaseText, ''
      assert.notEqual q.wayText, ''

    it 'multiple choices', ->
      @base.way = 'multiple_choices'
      q = new Question(@base)
      assert.equal q.isMultipleChoices(), true
      assert.notEqual q.pleaseText, ''
      assert.notEqual q.wayText, ''

    it 'free text', ->
      @base.way = 'free_text'
      q = new Question(@base)
      assert.equal q.isFreeText(), true
      assert.notEqual q.pleaseText, ''
      assert.notEqual q.wayText, ''

    it 'in_order', ->
      @base.way = 'in_order'
      q = new Question(@base)
      assert.equal q.isInOrder(), true
      assert.notEqual q.pleaseText, ''
      assert.notEqual q.wayText, ''

    it 'ox', ->
      @base.way = 'ox'
      q = new Question(@base)
      assert.equal q.isOx(), true
      assert.notEqual q.pleaseText, ''
      assert.notEqual q.wayText, ''

    it 'multiple questions', ->
      child = _.clone(@base)
      @base.way = 'multiple_questions'
      @base.children = [child, child]
      q = new Question(@base)
      assert.equal q.isMultipleQuestions(), true
      assert.equal q.children.length, 2
      assert.equal q.hasChildren(), true
      assert.notEqual q.pleaseText, ''
      assert.notEqual q.wayText, ''

  describe 'trim', ->
    it 'html triming', ->
      assert.equal Question.trim('<h2 id="-">選択肢</h2>\n'), '選択肢\n'
