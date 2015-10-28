gulp = require 'gulp'
mocha = require 'gulp-mocha'
plumber = require 'gulp-plumber'

src = './test/**/*.coffee'

onError = (err)->
  console.log(err.toString())
  @emit("end")

gulp.task 'mocha', ->
  require 'espower-coffee/guess'
  gulp.src './test/**/*.coffee'
    .pipe mocha()

gulp.task 'default', ->
  gulp.watch(src).on 'change', (e) ->
    require 'espower-coffee/guess'
    gulp.src e.path
      .pipe(plumber())
      .pipe mocha()
