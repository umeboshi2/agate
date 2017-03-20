gulp = require 'gulp'
gutil = require 'gulp-util'
size = require 'gulp-size'
sourcemaps = require 'gulp-sourcemaps'

coffee = require 'gulp-coffee'


gulp.task 'coffee', () ->
  gulp.src('./src/**/*.coffee')
  .pipe sourcemaps.init()
  .pipe coffee
    bare: true
  .pipe sourcemaps.write()
  .on 'error', gutil.log
  .pipe size
    showFiles: true
  .pipe gulp.dest './dist'


gulp.task 'default', ->
  gulp.start 'coffee'
  
