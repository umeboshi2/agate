path = require 'path'
os = require 'os'


webpack = require 'webpack'

ManifestPlugin = require 'webpack-manifest-plugin'
StatsPlugin = require 'stats-webpack-plugin'

loaders = require './webpack-config/loaders'
entries = require './webpack-config/entries'
resolve = require './webpack-config/resolve'

local_build_dir = "dist"

BuildEnvironment = 'dev'
if process.env.PRODUCTION_BUILD
  BuildEnvironment = 'production'
  Clean = require 'clean-webpack-plugin'
  console.log "==============PRODUCTION BUILD=============="
  
WebPackOutputFilename =
  dev: '[name].js'
  production: '[name].min.js'
  
WebPackOutput =
  filename: WebPackOutputFilename[BuildEnvironment]
  path: path.join __dirname, local_build_dir
  library: 'agate'
  libraryTarget: 'commonjs'
  
DefinePluginOpts =
  dev:
    __DEV__: 'true'
    DEBUG: JSON.stringify(JSON.parse(process.env.DEBUG || 'false'))
  production:
    __DEV__: 'false'
    DEBUG: 'false'
    'process.env':
      'NODE_ENV': JSON.stringify 'production'
    
StatsPluginFilename =
  dev: 'stats-dev.json'
  production: 'stats.json'

VendorFilename =
  dev: 'vendor.js'
  production: 'vendor-[chunkhash].js'
  
    
common_plugins = [
  new webpack.DefinePlugin DefinePluginOpts[BuildEnvironment]
  # FIXME: we probably want vendor.js for multipage sites
  #new webpack.optimize.CommonsChunkPlugin
  #  name: 'vendor'
  #  filename: VendorFilename[BuildEnvironment]
  new webpack.optimize.OccurenceOrderPlugin true
  new webpack.optimize.AggressiveMergingPlugin()
  new StatsPlugin StatsPluginFilename[BuildEnvironment], chunkModules: true
  new ManifestPlugin()
  # This is to ignore moment locales with fullcalendar
  # https://github.com/moment/moment/issues/2416#issuecomment-111713308
  new webpack.IgnorePlugin /^\.\/locale$/, /moment$/
  ]

if BuildEnvironment is 'dev'
  dev_only_plugins = []
  AllPlugins = common_plugins.concat dev_only_plugins
else if BuildEnvironment is 'production'
  prod_only_plugins = [
    # production only plugins below
    new webpack.optimize.DedupePlugin()
    new webpack.optimize.UglifyJsPlugin
      compress:
        warnings: true
    #new ChunkManifestPlugin
    #  filename: 'chunk-manifest.json'
    #  manifestVariable: 'webpackManifest'
    new Clean local_build_dir
    ]
  AllPlugins = common_plugins.concat prod_only_plugins
else
  console.error "Bad BuildEnvironment", BuildEnvironment
  


WebPackConfig =
  entry: entries
  output: WebPackOutput
  plugins: AllPlugins
  module:
    loaders: loaders
  resolve: resolve
  externals: /^[a-z\-0-9]+$/
  
if BuildEnvironment is 'dev'
  #proxy = require './webpack-config/devserver-proxies'
  WebPackConfig.devServer =
    host: os.hostname()
    #proxy: proxy
    historyApiFallback:
      index: 'index-dev.html'
  WebPackConfig.devtool = 'source-map'

  # http://stackoverflow.com/a/11276104
  #console.log JSON.stringify proxy, null, 4
  # http://stackoverflow.com/a/33707230
  #console.dir proxy, { depth:null, colors:true}

  #console.log "=====================WEBPACK PROXY CONFIG================="
  #prettyjson = require 'prettyjson'
  #console.log prettyjson.render proxy
  #console.log "=====================WEBPACK PROXY CONFIG================="
  
module.exports = WebPackConfig
