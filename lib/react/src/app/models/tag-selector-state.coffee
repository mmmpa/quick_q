#
# TagSelectorのステート
#
module.exports = class TagSelectorState
  #タグを選んだ直後の状態
  @TOGGLED = 'question loading'

  #タグリストを更新中
  @LOADING = 'loading tag'

  #タグリストの更新が終わった
  @LOADED = 'loaded'

