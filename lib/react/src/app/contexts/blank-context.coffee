#
# Arda.RouterをreplaceContextで統一する最初に入れておくためのダミーコンテキスト
#
module.exports = class BlankContext extends Arda.Context
  initState: (props) -> props

  component: React.createClass (
    render: ->
      React.createElement('div.container', {}, "Now loading #{@props.name}...")
  )
