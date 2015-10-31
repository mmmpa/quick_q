#
# 出題用APIのquestionを整形するモデル
#
module.exports = class Question
  constructor: (obj)->
    @id = obj.id
    @text = obj.text || ''
    @options = (_.map(obj.options || [], (option) =>
      id: option.id
      marked: { __html: marked(option.text) }
    ))
    @answersNumber = obj.answers_number || -1
    @way = obj.way || ''

    @marked = { __html: marked(@text) }
    @description = Question.trim(@marked.__html).slice(0, 40)
    @wayText = Question.detectWayText(@)
    @pleaseText = Question.detectPleaseText(@)

  isSingleChoice: ->
    @way == 'single_choice'

  isMultipleChoices: ->
    @way == 'multiple_choices'

  isFreeText: ->
    @way == 'free_text'

  isInOrder: ->
    @way == 'in_order'

  isOx: ->
    @way == 'ox'

  @trim = (html)->
    html.replace(/<.*?>/igm, '')

  @detectPleaseText = (q)->
    switch
      when q.isSingleChoice()
        'ひとつ選んでください'
      when q.isMultipleChoices()
        '適切なものをすべて選んでください'
      when q.isFreeText()
        '答えを入力してください'
      when q.isInOrder()
        'それぞれに対応するものを選んでください'
      when q.isOx()
        'いずれかを選んでください'
      else
        ''

  @detectWayText = (q)->
    switch
      when q.isSingleChoice()
        '一つだけ選択'
      when q.isMultipleChoices()
        '複数選択'
      when q.isFreeText()
        'テキスト入力'
      when q.isInOrder()
        '順に並べる'
      when q.isOx()
        'ox問題'
      else
        ''
