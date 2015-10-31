path = require 'path'

module.exports = config = {}

pathes = {
    app: path.join(__dirname, '../src/app'),
    model: path.join(__dirname, '../src/app/models')
}

config.path = (name, tail)->
  path.join(pathes[name], tail)

global.React   = require 'react'
global.Promise = require 'bluebird'
global.Arda = require 'arda'
global._ = require 'lodash'
global.marked = require('marked')