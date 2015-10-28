fs = require 'fs'
path = require 'path'
changeCase = require 'change-case'
_ = require 'lodash'

module.exports = generateJsxCoffee = (dir, parents = [])->
  console.log parents
  container = changeCase.pascalCase(pickDirName(dir))

  level = parents.length + 1

  files = fs.readdirSync(dir)

  requests = files.map (file)->
    full = path.join(dir, file)

    if fs.statSync(full).isDirectory()
      nextParents = parents.concat()
      nextParents.push(file)
      return generateJsxCoffee(full, nextParents)
    else
      return null unless file.match(/.js$/)
      fileName = file.split('.').shift()
      name = changeCase.camelCase(fileName)
      nowParents = parents.concat(fileName)
      genSpace(level) + "#{name}: require './#{nowParents.join('/')}.js'"

  if parents.length
    requests.unshift genSpace(level - 1) + changeCase.pascalCase(_.last(parents)) + ':'

  if parents.length
    return _.compact(requests).join('\n')

  requests.unshift 'module.exports = JSX = {'
  requests.push '}'
  console.log 'generate', jsxCoffee = path.join(dir, 'jsx.coffee')
  fs.writeFileSync jsxCoffee, _.compact(requests).join("\n")

genSpace = (n)->
  space = ''
  _.times(n * 2, -> space += ' ')
  space


pickDirName = (dir)->
  dirs = dir.split('/')
  if (last = _.last(dirs)) != ''
    last
  else
    dirs[dirs.length - 2]


if require.main == module
  dir = process.argv[2]
  generateIndexCoffee(dir) if dir?
