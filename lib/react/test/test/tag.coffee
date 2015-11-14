config = require '../helper'
assert = require 'power-assert'
Tag = require config.path('model', 'tag')
App.Linker = require config.path('model', 'linker')
App.Path = require config.path('app', 'path')

describe 'Tag', ->
  describe 'Base', ->
    it 'attributes', ->
      tag = new Tag(
        id: 1
        display: 'display'
        count: 0
      )
      assert.equal tag.id, 1
      assert.equal tag.display, 'display'
      assert.notEqual tag.countText, null
      assert.notEqual tag.linker, null
      assert.notEqual tag.uri, null
      assert.equal tag.hasQuestion(), false

    it 'attributes', ->
      tag = new Tag(
        id: 1
        display: 'display'
        count: 1
      )
      assert.equal tag.hasQuestion(), true
