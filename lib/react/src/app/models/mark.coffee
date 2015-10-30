module.exports = class Mark
  constructor: (@mark, @options)->
    @resultText = if @mark.mark
      '正解!!'
    else
      '不正解'

    @answers = _.flatten([@mark.correct_answer])

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

  is_correct: ->
    @mark.mark