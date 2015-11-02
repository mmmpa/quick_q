module.exports = class DummyContext
  @header = {}
  @struck = {}
  @emit: ->
  @strikeApi: (linker)->
    new Promise((resolve, reject)=>
      resolve(
        header: @header
        body: @struck
      )
    )
