#
# Notifierに渡すデータモデル
#
# = Example
#
#   App.Notice.danger('Cannot Undo!', 'Are you OK?')
#
module.exports = class Notice
  constructor: (@type, @title, @message)->

  @danger = @red = (title, message)->
    new @('danger', title, message)

  @success = @green = (title, message)->
    new @('success', title, message)

  @information = @yellow = (title, message)->
    new @('info', title, message)

  @primary = @blue = (title, message)->
    new @('primary', title, message)