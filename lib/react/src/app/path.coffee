module.exports = Path =
  portal: '/'
  q: '/q/:id'
  qIndex: '/q'
  mark: '/marks'
  tags: '/tags'
  taggedTags: '/tags/tagged/:tags'
  taggedIndex: '/q/tagged/:tags'
  sources: '/src'
  render: (path, values)->
    _.reduce(values, (a, value, key)->
      a.replace("%{#{key}}", value)
    , Path[path])
