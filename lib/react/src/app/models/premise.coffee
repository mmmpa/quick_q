#
# 問題の前提を整形するモデル
#
module.exports = class Premise
  constructor: (obj)->
    @id = obj.id
    @text = obj.text || ''
    @marked = { __html: marked(@text) }
