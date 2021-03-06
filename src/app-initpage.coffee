Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
  
require 'bootstrap'

require './messages'

{ MainPageLayout } = require './views/layout'
{ BootstrapNavBarView } = require './views/navbar'
MessagesView = require './views/messages'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'

initialize_page = (app) ->
  #regions = MainChannel.request 'main:app:regions'
  appmodel = MainChannel.request 'main:app:appmodel'
  # create layout view
  if appmodel.has 'appView'
    AppView = appmodel.get 'appView'
  else
    AppView = MainPageLayout
    
  layout_opts = {}
  if appmodel.has 'layout_template'
    layout_opts.template = appmodel.get 'layout_template'
  layout = new AppView layout_opts
  # set the main layout view to create and show
  # the navbar when it is shown.  This assures us
  # that the $el is present in the DOM. 
  layout.on 'render', ->
    # FIXME create footer view
    # 
    # This is used to get regions in the root layout
    MainChannel.reply 'main:app:get-region', (region) ->
      app.getView().getRegion(region)
      
    if appmodel.has 'navbarView'
      if __DEV__
        console.log "using custom navbar_viewclass"
      nbclass = appmodel.get 'navbarView'
    else
      nbclass = BootstrapNavBarView
    navbar = new nbclass
      model: appmodel
    layout.showChildView 'navbar', navbar
    messages = new MessagesView
      collection: MessageChannel.request 'messages'
    layout.showChildView 'messages', messages
  
  app.showView layout
  
module.exports = initialize_page
