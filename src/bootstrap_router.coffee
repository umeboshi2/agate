Marionette = require 'backbone.marionette'
Util = require './apputil'

class BootStrapAppRouter extends Marionette.AppRouter
  onRoute: (name, path, args) ->
    #console.log "onRoute name: #{name}, path: #{path}, args: #{args}"
    Util.navbar_set_active path
        
module.exports = BootStrapAppRouter
