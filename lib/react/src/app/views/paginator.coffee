module.exports = Paginator = React.createClass(
  mixins: [Arda.mixin]

  render: ->
    App.JSX.paginator(
      links: @links()
      paginate: (page)=>
        @dispatch('question:index:paginate', page)
    )

  links: ->
    _.map([1..@props.header.total], (n)=>
      isCurrent: +@props.header.page == n
      page: n
    )
)