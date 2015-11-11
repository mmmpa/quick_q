#
# タグモデル
#
module.exports = class Tag
  constructor: (obj)->
    @id = obj.id
    @display = obj.display
    @count = obj.count
    @countText = "(#{@count})"
    @linker = App.Linker.get(App.Path.taggedIndex, tags: @id)
    @uri = @linker.paramsUri

  has_question: ->
    @count > 0

