config = require '../helper'
assert = require 'power-assert'
ApiStriker = require config.path('model', 'api-striker')
App.Linker = require config.path('model', 'linker')
App.Path = require config.path('app', 'path')
nock = require 'nock'

nock 'http://localhost'
.get '/'
.reply 200, {
  hello: 'world'
}, {
  'Content-Type': 'application/json'
}

describe 'ApiStriker', ->
  describe.skip 'Base', ->
    it 'attributes', ->
      skip