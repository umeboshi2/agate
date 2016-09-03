Backbone = require 'backbone'
Marionette = require 'backbone.marionette'


NavTemplates = require './templates/navbar'
LayoutTemplates = require './templates/layout'
MiscTemplates = require './templates/misc'
MenuTemplates = require './templates/menus'

{ BootstrapModalRegion } = require './regions'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'

class MainPageLayout extends Backbone.Marionette.View
  template: LayoutTemplates.MainFluidLayoutTemplate
  regions:
    messages: '#messages'
    navbar: '#navbar-view-container'
    #modal: '#modal'
    modal: BootstrapModalRegion
    applet: '#applet-content'
    footer: '#footer'
    
    
    
class DefaultAppletLayout extends Backbone.Marionette.View
  template: LayoutTemplates.make_sidebar_template()
  regions:
    sidebar: '#sidebar'
    content: '#main-content'
  
class BootstrapNavBarView extends Backbone.Marionette.View
  template: NavTemplates.nav_pt
  regions:
    usermenu: '#user-menu'
    mainmenu: '#main-menu'
    

class MainSearchFormView extends Backbone.Marionette.View
  template: NavTemplates.nav_pt_search

class UserMenuView extends Backbone.Marionette.View
  template: MenuTemplates.user_menu

class MessageView extends Backbone.Marionette.View
  template:MiscTemplates.message_box
  ui:
    close_button: 'button.close'

  events:
    'click @ui.close_button': 'destroy_message'

  destroy_message: ->
    #console.log "Destroy message", @model.get("content")
    MessageChannel.request 'delete-message', @model
    

class MessagesView extends Backbone.Marionette.CollectionView
  childView: MessageView
  
  
module.exports =
  MainPageLayout: MainPageLayout
  DefaultAppletLayout: DefaultAppletLayout
  MainSearchFormView: MainSearchFormView
  BootstrapNavBarView: BootstrapNavBarView
  UserMenuView: UserMenuView
  MessagesView: MessagesView
  

