((root, factory) ->
  if typeof define == 'function' and define.amd
    define [
      'backbone.marionette'
      'backbone.radio'
      'underscore'
    ], factory
  else if typeof exports != 'undefined'
    module.exports = factory(require('backbone.marionette'), require('backbone.radio'), require('underscore'))
  else
    factory root.Backbone.Marionette, root.Backbone.Radio, root._
  return
) this, (Marionette, Radio, _) ->
  'use strict'

  Marionette.Application::_initChannel = ->
    @channelName = _.result(this, 'channelName') or 'global'
    @channel = _.result(this, 'channel') or Radio.channel(@channelName)
    return

  return
