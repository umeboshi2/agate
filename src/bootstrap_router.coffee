Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
Util = require './apputil'

class BootStrapAppRouter extends Backbone.Marionette.AppRouter
  onRoute: (name, path, args) ->
    #console.log "onRoute name: #{name}, path: #{path}, args: #{args}"
    Util.navbar_set_active path
    # FIXME figure out how to do this better in the controller
    if @getOption 'empty_sidebar_on_route'
      controller = @getOption 'controller'
      controller._empty_sidebar()

module.exports = BootStrapAppRouter
