# inspired by https://github.com/KyleAMathews/coffee-react-quickstart
# 
fs = require 'fs'

gulp = require 'gulp'
gutil = require 'gulp-util'
size = require 'gulp-size'
coffee = require 'gulp-coffee'
nodemon = require 'gulp-nodemon'
#runSequence = require 'run-sequence'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'

webpack = require 'webpack'

gulp.task 'webpack:build-prod', (callback) ->
  # run webpack
  process.env.PRODUCTION_BUILD = 'true'
  ProdConfig = require './webpack.config'
  prodCompiler = webpack ProdConfig
  prodCompiler.run (err, stats) ->
    throw new gutil.PluginError('webpack:build-prod', err) if err
    gutil.log "[webpack:build-prod]", stats.toString(colors: true)
    callback()
    return
  return

gulp.task 'default', ->
  gulp.start 'webpack:build-prod'
  

gulp.task 'production', ->
  gulp.start 'webpack:build-prod'
