Marionette = require 'backbone.marionette'
Toolkit = require 'marionette.toolkit'
tc = require 'teacup'

class BootstrapModalRegion extends Marionette.Region
  el: '#modal'
  backdrop: false
  
  getEl: (selector) ->
    $el = $ selector
    $el.attr 'class', 'modal'
    $el
    
  show: (view) ->
    super view
    @$el.modal
      backdrop: @backdrop
    @$el.modal 'show'

class MainPageLayout extends Marionette.View
  template: tc.renderable () -> 
    tc.div '#navbar-view-container'
    tc.div ".container-fluid", ->
      tc.div '.row', ->
        tc.div '.col-sm-10.col-sm-offset-1', ->
          tc.div '#messages'
      tc.div '#applet-content.row'
    tc.div '#footer'
    tc.div '#modal'

  regions:
    messages: '#messages'
    navbar: '#navbar-view-container'
    modal: BootstrapModalRegion
    applet: '#applet-content'
    footer: '#footer'
    
module.exports = MainPageLayout


