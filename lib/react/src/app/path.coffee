module.exports = Path =
  portal: '/'
  q: '/q/:id'
  qIndex: '/q'
  qTags: '/q/:id/tag'
  next: '/q/tagged/:tags/:id/next'
  mark: '/marks'
  tags: '/tags'
  taggedTags: '/tags/tagged/:tags'
  taggedIndex: '/q/tagged/:tags'
  sources: '/src'
  source: '/src/:id'
  premise: '/premises/:id'
  render: (path, values)->
    _.reduce(values, (a, value, key)->
      a.replace("%{#{key}}", value)
    , Path[path])
