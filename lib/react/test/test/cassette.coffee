config = require '../helper'
assert = require 'power-assert'
Cassette = require config.path('model', 'cassette')

describe 'Cassette', ->
  describe 'Base', ->
    it 'attributes', ->
      Cassette.root = Arda
      cassette = new Cassette(React, { prop: 'p' })
      assert.deepEqual cassette.forPusher(), [React, { root: Arda, prop: 'p' }]
