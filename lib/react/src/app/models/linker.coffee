#
# scene:replaceをdispatchするときに一緒に渡すモデル
#
# = Attributes
#
# - key apiStrikeでgetアクセスのデータ保持用に使う。
#
# = Example
#
#   App.Linker.post('/user/new', {name: 'mmmpa', job: 'none'})
#
module.exports = class Linker
  constructor: (@method, @uri, @params)->
    @_replacePlaceholder()
    @key = @uri + '::' + (for key, value of @params
        "#{key}:#{value}"
      ).join('::')
    @paramsUri = if @isGet && @params
      @uri + '?' + (for key, value of @params
        encodeURIComponent(key) + "=" + encodeURIComponent(value)
      ).join('&')
    else
      @uri

  _replacePlaceholder: ->
    while @uri.match(/(:([0-9_a-z]+))/)
      @uri = @uri.replace(RegExp.$1, @params[RegExp.$2] || '')
      delete @params[RegExp.$2]

  isGet: ->
    @method == 'get'

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


