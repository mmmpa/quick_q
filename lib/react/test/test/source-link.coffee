config = require '../helper'
assert = require 'power-assert'
SourceLink = require config.path('model', 'source-link')

describe 'SourceLink', ->
  describe 'Base', ->
    it 'attributes', ->
      link = new SourceLink(
        id: 1
        display: 'display'
        url: 'url'
      )
      assert.equal link.id, 1
      assert.equal link.display, 'display'
      assert.equal link.url, 'url'
