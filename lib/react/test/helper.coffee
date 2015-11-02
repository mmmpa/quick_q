jsdom = require 'jsdom'
global.navigator = { userAgent: 'node.js' }
global.document = jsdom.jsdom('<!doctype html><html><p id="main"></p><article id="app"></article></html>')
global.window = document.defaultView
global.$ = require('jquery')

global.React = require 'react'
global.Promise = require 'bluebird'
global.Arda = require 'arda'
global._ = require 'lodash'
global.marked = require('marked')

path = require 'path'

module.exports = config = {}

pathes = {
  app: path.join(__dirname, '../src/app'),
  model: path.join(__dirname, '../src/app/models')
  support: path.join(__dirname, './supports')
}

config.path = (name, tail)->
  path.join(pathes[name], tail)

config.params =
  singleChoice:
    id: 1
    text: '# 問題文'
    way: 'single_choice'
    options: [
      {
        id: 1
        text: '## 選択肢1\n'
      }
      {
        id: 2
        text: '## 選択肢2\n'
      }
      {
        id: 3
        text: '## 選択肢3\n'
      }
    ]

  multipleChoices:
    id: 1
    text: '# 問題文'
    way: 'multiple_choices'
    options: [
      {
        id: 1
        text: '## 選択肢1\n'
      }
      {
        id: 2
        text: '## 選択肢2\n'
      }
      {
        id: 3
        text: '## 選択肢3\n'
      }
    ]

  inOrder:
    id: 1
    text: '# 問題文'
    way: 'in_order'
    answers_number: 5
    options: [
      {
        id: 1
        text: '## 選択肢1\n'
      }
      {
        id: 2
        text: '## 選択肢2\n'
      }
      {
        id: 3
        text: '## 選択肢3\n'
      }
    ]

  freeText:
    id: 1
    text: '# 問題文'
    way: 'free_text'

  ox:
    id: 1
    text: '# 問題文'
    way: 'ox'
