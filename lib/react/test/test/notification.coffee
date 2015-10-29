config = require '../helper'
assert = require 'power-assert'
Notice = require config.path('model', 'notice')

describe 'Notice', ->
  describe 'Base', ->
    it 'attributes', ->
      notice = new Notice('danger', 'Cannot Undo', 'OK??')
      assert.equal notice.type, 'danger'
      assert.equal notice.title, 'Cannot Undo'
      assert.equal notice.message, 'OK??'

  describe 'Short hand method', ->
    before ->
      @title = 'title'
      @message = 'message'

    it 'danger', ->
      notice = Notice.danger(@title, @message)
      assert.equal notice.type, 'danger'
      assert.equal notice.title, @title
      assert.equal notice.message, @message

    it 'red', ->
      notice = Notice.red(@title, @message)
      assert.equal notice.type, 'danger'
      assert.equal notice.title, @title
      assert.equal notice.message, @message

    it 'success', ->
      notice = Notice.success(@title, @message)
      assert.equal notice.type, 'success'
      assert.equal notice.title, @title
      assert.equal notice.message, @message

    it 'green', ->
      notice = Notice.green(@title, @message)
      assert.equal notice.type, 'success'
      assert.equal notice.title, @title
      assert.equal notice.message, @message

    it 'information', ->
      notice = Notice.information(@title, @message)
      assert.equal notice.type, 'info'
      assert.equal notice.title, @title
      assert.equal notice.message, @message

    it 'yellow', ->
      notice = Notice.yellow(@title, @message)
      assert.equal notice.type, 'info'
      assert.equal notice.title, @title
      assert.equal notice.message, @message

    it 'primary', ->
      notice = Notice.primary(@title, @message)
      assert.equal notice.type, 'primary'
      assert.equal notice.title, @title
      assert.equal notice.message, @message

    it 'blue', ->
      notice = Notice.blue(@title, @message)
      assert.equal notice.type, 'primary'
      assert.equal notice.title, @title
      assert.equal notice.message, @message
