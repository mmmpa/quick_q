#
# アプリケーション全体のメニューを扱うコンテキスト
# ゲストかアカウントかで切り替えるが未実装なのでブランク。
#
module.exports = class GlobalContext extends App.BaseContext
  initState: (props) -> props

  component: React.createClass (
    render: ->
      React.createElement('div', {})
  )
