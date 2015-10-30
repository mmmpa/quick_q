module.exports = Path =
  portal: '/'
  q: '/q/:id'
  qIndex: '/q'
  mark: '/marks'
  render: (path, values)->
    _.reduce(values, (a, value, key)->
      a.replace("%{#{key}}", value)
    , Path[path])
