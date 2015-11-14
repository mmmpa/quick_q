#
# アプリケーション全体のメニューを扱うコンテキスト
# ゲストかアカウントかで切り替えるが未実装なのでブランク。
#
module.exports = class GlobalContext extends App.BaseContext
  component: React.createClass (
    mixins: [Arda.mixin]

    render: ->
      App.JSX.Menu.menu(
        Fa: App.View.Fa
        goHome: =>
          @dispatch('app:home')
      )
  )

  initState: (props) -> props
  expandComponentProps: (props, state) -> state

  delegate: (subscribe) ->
    super
    subscribe 'app:home', -> @root.emit('app:home')
    subscribe 'context:created', -> console.log 'created'
    subscribe 'context:started', -> console.log 'started'

