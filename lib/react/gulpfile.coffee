gulp = require 'gulp'

browserify = require 'browserify'
coffee = require 'gulp-coffee'
compass = require 'gulp-compass'
#jade = require 'gulp-jade'
sass = require 'gulp-ruby-sass'
streamify = require 'gulp-streamify'
replace = require('gulp-replace')

concat = require 'gulp-concat'
minify = require 'gulp-minify-css'
plumber = require 'gulp-plumber'
rename = require 'gulp-rename'
source = require 'vinyl-source-stream'
uglify = require 'gulp-uglify'
changeCase = require 'change-case'
notify = require 'gulp-notify'

argv = require('yargs').argv
spawn = require('child_process').spawn
shell = require('gulp-shell')
reactJade = require('react-jade');
fs = require 'fs'
jade = require '@mizchi/gulp-react-jade'

path = require 'path'
fs = require "fs"
_ = require 'lodash'

generateIndexCoffee = require './index-coffee-generator'
generateJsxCoffee = require './jsx-coffee-generator'

rootPath = path.join(__dirname, './')
tempPath = path.join(__dirname, 'temp')
publicJsPath = path.join(rootPath, '../../public/js')

onError = (err)->
  console.log(err.toString())
  @emit("end")

split = (filePath)->
  _(path.relative(rootPath, filePath).split('/')).drop(2).dropRight(1).value()

genPath = (dirs, filePath)->
  dirs.concat(split(filePath)).join('/')


gulp.task 'default', ->
  p = undefined

  spawnChildren = (e) ->
    if p
      p.kill()
    p = spawn('gulp', ['build', 'building', 'reload-assets'], stdio: 'inherit')

  gulp.watch 'gulpfile.coffee', spawnChildren
  spawnChildren null

# react-jade-build

gulp.task 'jsx', ->
  generateJsxCoffee path.join(rootPath, 'src/app/jsx/')

gulp.task 'reload-assets', ->
  assets = path.join(rootPath, '../../app/assets/**/*.*')
  gulp.watch(assets).on 'change', (e) ->
    gulp.src(e.path)
    .pipe shell([
        'wget "http://127.0.0.1:3000" -O /dev/null',
        'echo done'
      ], {
        templateData: {
          outpath: (s) ->
        }
      })

gulp.task 'building', ->
  reactJadeWatch = path.join(rootPath, 'src/app/jsx/**/*.jade')

  gulp.watch(reactJadeWatch).on 'change', (e) ->
    dest = genPath(['src', 'app'], e.path)
    fileName = e.path.split('/').pop().split('.').shift()
    try
      generated = 'module.exports = ' + reactJade.compileFileClient(e.path).replace(/typeof React !== "undefined" \? React : require\(".+react\.js"\)/, 'React')

      fs.writeFileSync(path.join(dest, fileName + '.js'), generated)
      console.log "generated #{dest} #{fileName}"
    catch error
      console.log error

    generateJsxCoffee path.join(rootPath, 'src/app/jsx/')

# application build

gulp.task 'build', ->
  appWatch = path.join(rootPath, 'src/app/**/*.coffee')
  reactJadeWatch = path.join(rootPath, 'src/app/jsx/jsx.coffee')
  jsx = path.join(rootPath, 'src/app/jsx/jsx.coffee')
  src = path.join(rootPath, 'src/app/app.coffee')
  reqDirs = [path.join(rootPath, 'src/app/contexts'), path.join(rootPath, 'src/app/views'), path.join(rootPath, 'src/app/models')]

  # generate index.coffee for require
  generateReqs = ->
    reqDirs.map((dir)->
      generateIndexCoffee(dir)
    )

  gulp.watch([appWatch, reactJadeWatch, jsx]).on 'change', (e) ->
    return if e.path.split('/').pop() == 'index.coffee'
    generateReqs()

    browserify
      entries: src
      extensions: ['.coffee']
      debug: true
    .transform 'coffeeify'
    .bundle()
    .on('error', onError)
    .pipe source('dummy.js')
    #.pipe streamify(uglify())
    .pipe rename('build.min.js')
    .pipe gulp.dest(publicJsPath)
    .pipe notify message: 'complete'


# framework build

gulp.task 'vendor', ->
  browserify
    entries: ['./vendor.coffee']
    extensions: ['.coffee']
    debug: true
  .transform 'coffeeify'
  .plugin 'licensify'
  .bundle()
  .on('error', onError)
  .pipe source('vendor.js')
  .pipe streamify(uglify
      output:
        comments: /generated by licensify/
  )
  .pipe rename('vendor.min.js')
  .pipe gulp.dest(publicJsPath)
