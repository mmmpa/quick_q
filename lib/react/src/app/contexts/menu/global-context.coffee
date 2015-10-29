#
# アプリケーション全体のメニューを扱うコンテキスト
# ゲストかアカウントかで切り替えるが未実装なのでブランク。
#
module.exports = class GlobalContext extends Arda.Context
  initState: (props) -> props

  component: React.createClass (
    render: ->
      React.createElement('div', {})
  )
