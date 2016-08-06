# config resolve.
path = require 'path'
webpack = require 'webpack'

aliases = require './resolve-aliases'

module.exports =
  alias: aliases
  modulesDirectories: [
    'node_modules'
    'bower_components'
    ]
  extensions: [
    # MUST include empty string
    # https://webpack.github.io/docs/configuration.html#resolve-extensions
    ''
    '.webpack.js'
    '.web.js'
    '.js'
    # add coffescript files to the list
    '.coffee'
  ]
  plugins: [
    new webpack.ResolverPlugin
      new webpack.ResolverPlugin.DirectoryDescriptionFilePlugin
        "bower.json", ["main"]
      ['normal', 'loader']
  ]


