#
# ルーターからの返り値を統一するためのモデル。
# そのままpushContextできる。
#
module.exports = class Cassette
  @root = null
  constructor: (@component, @props)->

  forPusher: ->
    [@component, _.merge(@props, root: Cassette.root)]