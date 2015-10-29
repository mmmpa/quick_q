module.exports = class Cassette
  constructor: (@component, @props)->

  forPusher: ->
    [@component, @props]