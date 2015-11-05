#
# 出題用APIのquestionを整形するモデル
#
module.exports = class Question
  constructor: (obj)->
    @id = obj.id
    @way = obj.way || ''
    @text = obj.text || ''
    @options = (_.map(obj.options || [], (option) =>
      id: option.id
      marked: if @isInOrder()
        { __html: Question.trim(marked(option.text)) }
      else
        { __html: marked(option.text) }
    ))

    @answersNumber = obj.answers_number || -1
    @sourceLinkId = obj.source_link_id
    @premiseId = obj.premise_id
    @marked = { __html: marked(@text) }
    @description = Question.trim(@marked.__html).slice(0, 40)
    @wayText = Question.detectWayText(@)
    @pleaseText = Question.detectPleaseText(@)
    @index = obj.index

    @children = if obj.children
      _.map(obj.children, (child, index)->
        child.index = index
        new Question(child)
      )

  hasChildren: ->
    @children && @children.length != 0

  hasSource: ->
    @sourceLinkId != null && @sourceLinkId != undefined

  hasPremise: ->
    @premiseId != null && @premiseId != undefined

  isMultipleQuestions: ->
    @way == 'multiple_questions'

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
      when q.isMultipleQuestions()
        'すべての設問に回答してください'
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
      when q.isMultipleQuestions()
        '複数の設問'
      else
        ''
