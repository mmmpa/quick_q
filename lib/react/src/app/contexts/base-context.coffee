module.exports = class BaseContext extends Arda.Context
  delegate: (subscribe) ->
    super

    subscribe 'context:created', ->
      @root = @props.root

    subscribe 'inform:rendered', ->
      @root.emit('inform:rendered')

  strikeApi: (linker)->
    @root.strikeApi(linker)

  _strippedPath: ->
    @root._strippedPath()

  _choppedPath: ->
    @root._choppedPath()
