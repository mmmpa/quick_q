config = require '../helper'
assert = require 'power-assert'
Premise = require config.path('model', 'premise')

describe 'Premise', ->
  describe 'Base', ->
    it 'attributes', ->
      premise = new Premise(
        id: 1
        text: '# title'
      )
      assert.equal premise.id, 1
      assert.equal premise.text, '# title'
      assert.deepEqual premise.marked, {__html: '<h1 id="title">title</h1>\n'}

    it 'attributes', ->
      premise = new Premise(
        id: 1
      )
      assert.equal premise.id, 1
      assert.equal premise.text, ''
      assert.deepEqual premise.marked, {__html: ''}
