#
# なんでも告げるコンテキスト。
# notify関係イベントがメインコンテキストから中継される。下部から直接は扱わない。
# とりあえずブランク
#
module.exports = class GodContext extends App.BaseContext
  initState: (props) -> props

  component: React.createClass (
    render: ->
      React.createElement('div', {})
  )
