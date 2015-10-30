module.exports = class Cassette
  @root = null
  constructor: (@component, @props)->

  forPusher: (root)->
    [@component, _.merge(@props, root: App.Cassette.root)]