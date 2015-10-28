fs = require 'fs'
path = require 'path'
changeCase = require 'change-case'

module.exports = class Generator
  constructor: ->
    @coffee = process.argv.shift()
    @me = process.argv.shift()
    @target = process.argv.shift()
    @rest = process.argv

  generate: ->
    switch @target
      when 'm', 'model'
        @generateModel(@rest...)
      when 'v', 'view'
        @generateView(@rest...)
      when 'c', 'context'
        @generateContext(@rest...)

  @prepareDir: (base, dirs)->
    now = []
    dirs.map((dir)->
      now.push(dir)
      nowDir = path.join(__dirname, base, now...)
      fs.mkdirSync(nowDir) unless fs.existsSync(nowDir)
    )

  @prepareParams: (base, name)->
    dirs = name.split('.').map((name)-> changeCase.paramCase(name))
    fileName = dirs.pop()
    resultFilePath = path.join(__dirname, base, dirs..., fileName + '.coffee')

    throw 'conflict' if fs.existsSync(resultFilePath)
    Generator.prepareDir(base, dirs)

    {
    dirs: dirs
    fileName: fileName
    resultFilePath: resultFilePath
    }

  @write: (template, fileName, resultFilePath)->
    fs.readFile(path.join(__dirname, template), (err, data)->
      throw err if err
      console.log data
      written = data.toString().replace(/__REPLACED_NAME/g, changeCase.pascalCase(fileName))
      fs.writeFileSync(resultFilePath, written)
    )

  generateModel: (name)->
    { fileName, resultFilePath } = Generator.prepareParams('src/app/models', name)
    Generator.write('template/model.coffee', fileName, resultFilePath)

  generateView: (name)->
    { fileName, resultFilePath } = Generator.prepareParams('src/app/views', name)
    Generator.write('template/view.coffee', fileName, resultFilePath)

  generateContext: (name)->
    { fileName, resultFilePath } = Generator.prepareParams('src/app/contexts', name)
    Generator.write('template/context.coffee', fileName, resultFilePath)
