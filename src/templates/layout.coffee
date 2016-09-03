tc = require 'teacup'


########################################
# Layout Templates
########################################
BootstrapLayoutTemplate = tc.renderable () ->
  tc.div '#main-navbar.navbar.navbar-default.navbar-fixed-top',
  role:'navigation'
  tc.div '.container-fluid', ->
    tc.div '.row', ->
      tc.div '#sidebar.col-sm-2'
      tc.div '#main-content.col-sm-9'
  tc.div '#footer'
  tc.div '#modal'

BootstrapNoGridLayoutTemplate = tc.renderable () ->
  tc.div '#main-navbar.navbar.navbar-default.navbar-fixed-top',
  role:'navigation'
  #div '#header.listview-header'
  tc.div '.main-layout', ->
    tc.div '#sidebar'
    tc.div '#main-content'
  tc.div '#footer'
  tc.div '#modal'

_MainLayoutTemplate = tc.renderable (container) ->
  tc.div '#navbar-view-container'
  #tc.div '#editor-bar-container'
  tc.div ".#{container}", ->
    tc.div '.row', ->
      tc.div '.col-md-10', ->
        tc.div '#messages'
    tc.div '#applet-content.row'
  tc.div '#footer'
  tc.div '#modal'

MainLayoutTemplate = ->
  _MainLayoutTemplate 'container'

MainFluidLayoutTemplate = ->
  _MainLayoutTemplate 'container-fluid'
  

MainContentTemplate = tc.renderable (doc) ->
  atts = doc.data.attributes
  tc.article '.document-view.content', ->
    tc.h1 atts.title
    tc.p '.lead', atts.description
    tc.div '.body', ->
      tc.raw atts.body
      
make_sidebar_template = (columns=3, size='sm', position='left') ->
  tc.renderable () ->
    if position is 'left'
      tc.div "#sidebar.col-#{size}-#{columns}.left-column"
    tc.div "#main-content.col-#{size}-#{12 - columns}"
    if position is 'right'
      tc.div "#sidebar.col-#{size}-#{columns}.right-column"

########################################
module.exports =
  BootstrapLayoutTemplate: BootstrapLayoutTemplate
  BootstrapNoGridLayoutTemplate: BootstrapNoGridLayoutTemplate
  MainLayoutTemplate: MainLayoutTemplate
  MainFluidLayoutTemplate: MainFluidLayoutTemplate
  MainContentTemplate: MainContentTemplate
  make_sidebar_template: make_sidebar_template
