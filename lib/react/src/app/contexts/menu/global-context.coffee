#
# アプリケーション全体のメニューを扱うコンテキスト
# ゲストかアカウントかで切り替えるが未実装なのでブランク。
#
module.exports = class GlobalContext extends App.BaseContext
  component: React.createClass (
    mixins: [Arda.mixin]

    render: ->
      App.JSX.Menu.menu(
        Fa:App.View.Fa
        goHome: =>
          @dispatch('app:home')
      )
  )

  initState: (props) -> props

  delegate: (subscribe) ->
    super
    subscribe 'app:home', (id)-> @root.emit('app:home')

