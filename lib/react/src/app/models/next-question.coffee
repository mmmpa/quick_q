#
#
#
module.exports = class NextQuestion
  constructor: (obj)->
    @id = obj.id
    @tagId = obj.tag_id
    @linker = App.Linker.get(App.Path.q, id: @id)
    @uri = @linker.paramsUri
    @display = "「#{obj.tag_display}」の次の問題"
