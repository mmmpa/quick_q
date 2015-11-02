config = require '../helper'
assert = require 'power-assert'
Linker = require config.path('model', 'linker')

describe 'Linker', ->
  describe 'Base', ->
    it 'attributes', ->
      linker = new Linker('get', '/', null)
      assert.equal linker.method, 'get'
      assert.equal linker.uri, '/'
      assert.equal linker.params, null

describe 'Short hand method', ->
  before ->
    @uri = '/user'
    @params = {id: 1, name: 'mmmpa'}

  it 'get', ->
    linker = Linker.get(@uri, @params)
    assert.equal linker.method, 'get'
    assert.equal linker.uri, @uri
    assert.deepEqual linker.params, @params

  it 'post', ->
    linker = Linker.post(@uri, @params)
    assert.equal linker.method, 'post'
    assert.equal linker.uri, @uri
    assert.deepEqual linker.params, @params

  it 'put', ->
    linker = Linker.put(@uri, @params)
    assert.equal linker.method, 'put'
    assert.equal linker.uri, @uri
    assert.deepEqual linker.params, @params

  it 'patch', ->
    linker = Linker.patch(@uri, @params)
    assert.equal linker.method, 'patch'
    assert.equal linker.uri, @uri
    assert.deepEqual linker.params, @params

  it 'delete', ->
    linker = Linker.delete(@uri, @params)
    assert.equal linker.method, 'delete'
    assert.equal linker.uri, @uri
    assert.deepEqual linker.params, @params

describe 'Placeholder auto replacement', ->
  it 'single', ->
    linker = Linker.get('/user/:id', {id: '1'})
    assert.equal linker.uri, '/user/1'
    assert.deepEqual linker.params, {}

  it 'multiple', ->
    linker = Linker.get('/user/:id/address/:index', {id: '1', index: '2'})
    assert.equal linker.uri, '/user/1/address/2'
    assert.deepEqual linker.params, {}

  it 'absent name', ->
    linker = Linker.get('/user/:id/address/:aid', {id: '1', index: '2'})
    assert.equal linker.uri, '/user/1/address/-'
    assert.deepEqual linker.params, {index: '2'}

