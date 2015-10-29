#
# scene:replaceをdispatchするときに一緒に渡すモデル
#
# = Example
#
#   App.Linker.post('/user/new', {name: 'mmmpa', job: 'none'})
#
module.exports = class Linker
  constructor: (@method, @uri, @params)->
    @_replacePlaceholder()

  _replacePlaceholder: ->
    while @uri.match(/(:([0-9_a-z]+))/)
      @uri = @uri.replace(RegExp.$1, @params[RegExp.$2] || '-')
      delete @params[RegExp.$2]

  @delete = (uri, params)->
    new @('delete', uri, params)

  @get = (uri, params)->
    new @('get', uri, params)

  @patch = (uri, params)->
    new @('patch', uri, params)

  @post = (uri, params)->
    new @('post', uri, params)

  @put = (uri, params)->
    new @('put', uri, params)


