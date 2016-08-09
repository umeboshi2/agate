$ = require 'jquery'
Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
marked = require 'marked'

MainViews = require './views'
Util = require './apputil'

MainChannel = Backbone.Radio.channel 'global'

class BaseController extends Backbone.Marionette.Object
  init_page: () ->
    # do nothing
  scroll_top: Util.scroll_top_fast
  navigate_to_url: Util.navigate_to_url
  navbar_set_active: Util.navbar_set_active

class MainController extends BaseController
  _get_region: (region) ->
    MainChannel.request 'main:app:get-region', region

  _show_content: (view) ->
    content = @_get_region 'content'
    content.show view

  _empty_sidebar: ->
    sidebar = @_get_region 'sidebar'
    sidebar.empty()
    sidebar
        
  _make_sidebar: ->
    sidebar = @_empty_sidebar()
    view = new @sidebarclass
      model: @sidebar_model
    sidebar.show view
    
  _show_view: (vclass, model) ->
    view = new vclass
      model: model
    @_show_content view

  _load_view: (vclass, model, objname) ->
    if model.isEmpty()
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

