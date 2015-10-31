#
# 正解確認用のmarks APIの結果を整形するモデル
#
module.exports = class Mark
  constructor: (@mark, @options)->
    @resultText = Mark.detectResultText(@)
    @answers = Mark.arralize(@mark.correct_answer)

    @correctAnswer = {
      __html: if @options.length
        _.map(@answers, (id)=>
          _.find(@options, (option)=>
            option.id == id
          ).marked.__html
        ).join('\n\n')
      else
        @mark.correct_answer
    }

  isCorrect: ->
    @mark.mark

  @arralize = (value)->
    if _.isArray(value)
      value
    else
      [value]

  @detectResultText = (mark)->
    if mark.isCorrect()
      '正解!!'
    else
      '不正解'

