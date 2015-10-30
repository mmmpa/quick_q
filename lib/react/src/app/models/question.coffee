module.exports = class Question
  constructor: (obj)->
    @id = obj.id
    @text = obj.text || ''
    @options = (for option in obj.options || []
      {
        id: option.id
        marked: {__html: marked(option.text)}
      }
    )
    @marked = {__html: marked(@text)}
    @description = App.Question.trim(@marked.__html).slice(0, 40)
    @way = obj.way || ''
    @wayText = App.Question.detectWayText(@way)

  @trim = (html)->
    html.replace(/<.*?>/igm, '')

  @detectWayText = (way)->
    switch way
      when 'single_choice'
        '一つだけ選択'
      when 'multiple_choices'
        '複数選択'
      when 'free_text'
        'テキスト入力'
      when 'in_order'
        '順に並べる'
      when 'ox'
        'ox問題'
      else
        ''