$ = require 'jquery'
Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

{ DefaultAppletLayout } = require './views/layout'
Util = require './apputil'

MainChannel = Backbone.Radio.channel 'global'

class BaseController extends Backbone.Marionette.Object
  init_page: () ->
    # do nothing
  scroll_top: Util.scroll_top_fast
  navigate_to_url: Util.navigate_to_url
  navbar_set_active: Util.navbar_set_active

class MainController extends BaseController
  layoutClass: DefaultAppletLayout
  _get_applet: ->
    app = MainChannel.request 'main:app:object'
    app.getView().getRegion 'applet'
    
  setup_layout: ->
    @layout = new @layoutClass
    #console.log "created layout", @layout
    applet = @_get_applet()
    if applet.hasView()
      #console.log "applet has view"
      applet.empty()
    applet.show @layout

  # use this method to create a layout only if
  # needed, making routing within the applet
  # more efficient.
  setup_layout_if_needed: ->
    if @layout is undefined
      #console.log 'layout is undefined'
      @setup_layout()
    else if @layout.isDestroyed()
      #console.log 'layout is destroyed ------>', @layout
      @setup_layout()
    
  
  _get_region: (region) ->
    @layout.getRegion region

  _show_content: (view) ->
    console.warn "_show_content is deprecated"
    content = @_get_region 'content'
    content.show view

  _empty_sidebar: ->
    sidebar = @_get_region 'sidebar'
    sidebar.empty()
    sidebar
        
  _make_sidebar: ->
    console.warn "_make_sidebar is deprecated"
    sidebar = @_empty_sidebar()
    view = new @sidebarclass
      model: @sidebar_model
    sidebar.show view
    
  _show_view: (vclass, model) ->
    view = new vclass
      model: model
    @layout.showChildView 'content', view

  _load_view: (vclass, model, objname) ->
    # FIXME
    # presume "id" is only attribute there if length is 1
    if model.isEmpty() or Object.keys(model.attributes).length is 1
      response = model.fetch()
      response.done =>
        @_show_view vclass, model
      response.fail =>
        msg = "Failed to load #{objname} data."
        MessageChannel.request 'danger', msg
    else
      @_show_view vclass, model
      
    
module.exports =
  BaseController: BaseController
  MainController: MainController

