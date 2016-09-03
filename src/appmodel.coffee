$ = require 'jquery'
jQuery = require 'jquery'
_ = require 'underscore'
Backbone = require 'backbone'


class BaseAppModel extends Backbone.Model
  defaults:
    apiRoot: '/api/dev'
    brand:
      name: 'Brand'
      url: '/'
    # FIXME frontdoor_app has to be statically required in
    # application.coffee
    frontdoor_app: 'frontdoor'
    userprofile_app: 'userprofile'
    hasUser: false
    needUser: false
    
    applets: []
    # applet_menus is a property that provides the ability
    # to organize the applets in dropdown menus on the
    # navbar.
    applet_menus: []

    # this is the region for the main view
    appRegion: 'body'

    # this is for a custom root view class
    # it should have these regions:
    # navbar, messages, modal, and applet
    appView: null

    # this is for a custom navbar view class
    navbarView: null

    # FIXME, I'm still using this for the navbar
    # but not for main layout.
    container: 'container'
    
    # FIXME regions and routes are not used
    regions: {}
    routes: []



example_applet_menu_entry =
  label: 'Applets'
  # The applets array is a list of appnames
  # described in the applets array of the
  # app model.
  applets: [ 'foo', 'bar', 'another']
  # If applets is empty, then check if
  # the nav entry is a single applet.
  # Set this to the name of an applet
  # for a single applet entry.
  single_applet: false
  # if single_applet is false, then use
  # a simple navbar link.
  url: '/this/is/used/if/applets/is/empty/for/plain/link'


class DefaultAppModel extends BaseAppModel

module.exports =
  BaseAppModel: BaseAppModel
  DefaultAppModel: DefaultAppModel
  
