module.exports = class DummyContext
  @struck = {}
  @emit: ->
  @strikeApi: (linker)->
    new Promise((resolve, reject)=>
      resolve(@struck)
    )
