#
# 出典モデル
#
module.exports = class SourceLink
  constructor: (obj)->
    @id = obj.id
    @display = obj.display
    @url = obj.url
