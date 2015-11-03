#
# タグモデル
#
module.exports = class Tag
  constructor: (obj)->
    @id = obj.id
    @display = obj.display
    @count = obj.count
    @countText = "(#{@count})"

  has_question: ->
    @count > 0

