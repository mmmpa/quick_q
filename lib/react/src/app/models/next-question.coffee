#
#
#
module.exports = class NextQuestion
  constructor: (obj)->
    if obj.next
      @nextQ =
        uri: App.Linker.get(App.Path.q, id: obj.next.id).paramsUri
        id: obj.next.id
      console.log @nextQ
    if obj.prev
      @prevQ =
        uri: App.Linker.get(App.Path.q, id: obj.prev.id).paramsUri
        id: obj.prev.id


