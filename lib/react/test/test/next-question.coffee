config = require '../helper'
assert = require 'power-assert'
NextQuestion = require config.path('model', 'next-question')
App.Linker = require config.path('model', 'linker')
App.Path = require config.path('app', 'path')

describe 'NextQuestion', ->
  describe 'Base', ->
    it 'attributes', ->
      q = new NextQuestion(
        next: null
        prev: null
      )
      assert.equal q.nextQ, null
      assert.equal q.prevQ, null

    it 'attributes', ->
      q = new NextQuestion(
        next: {id: 1}
        prev: {id: 2}
      )
      assert.equal q.nextQ.id, 1
      assert.equal q.prevQ.id, 2
      assert.notEqual q.nextQ.uri.indexOf('1'), -1
      assert.notEqual q.prevQ.uri.indexOf('2'), -1

