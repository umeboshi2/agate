$ = require 'jquery'
Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
Toolkit = require 'marionette.toolkit'
tc = require 'teacup'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'

class NavbarEntry extends Backbone.Model
  defaults:
    label: 'App Label'
    url: '#app'
    single_applet: false
    applets: []
    urls: []
    
class NavbarEntryCollection extends Backbone.Collection
  model: NavbarEntry

navbar_entry_collection = new NavbarEntryCollection
MainChannel.reply 'navbar-entries', ->
  navbar_entry_collection

MainChannel.reply 'new-navbar-entry', ->
  new NavbarEntry

MainChannel.reply 'add-navbar-entry', (atts) ->
  navbar_entry_collection.add atts
  
MainChannel.reply 'add-navbar-entries', (olist) ->
  navbar_entry_collection.add olist

##################################################
# we may remove the channel stuff later, or use it
##################################################

  
navbar_collapse_button  = tc.renderable (target) ->
  tc.button '.navbar-toggle', type:'button', 'data-toggle':'collapse',
  'data-target': "##{target}", ->
      tc.span '.sr-only', 'Toggle Navigation'
      tc.span '.icon-bar'
      tc.span '.icon-bar'
      tc.span '.icon-bar'

dropdown_toggle = tc.component (selector, attrs, renderContents) ->
  tc.a "#{selector}.dropdown-toggle", href:attrs.href,
  'data-toggle':'dropdown', renderContents

nav_pt_content = tc.renderable (appmodel) ->
  tc.div ".#{appmodel.container or 'container'}", ->
    tc.div '.navbar-header', ->
      navbar_collapse_button 'navbar-view-collapse'
      tc.a '.navbar-brand', href:'#', 'TKTest'
    tc.div '#navbar-view-collapse.collapse.navbar-collapse', ->
      tc.ul '.nav.navbar-nav.nav-pills', ->
      tc.ul '#user-menu.nav.navbar-nav.navbar-right'
      tc.div '#form-search-container'

nav_pt = tc.renderable (appmodel) ->
  tc.nav '#navbar-view.navbar.navbar-static-top.navbar-default',
  xmlns:'http://www.w3.org/1999/xhtml', 'xml:lang':'en',
  role:'navigation', ->
    tc.div '.container', ->
      tc.div '.navbar-header', ->
        navbar_collapse_button 'navbar-view-collapse'
        tc.a '.navbar-brand', href:'#', 'TkTest'
      tc.div '#navbar-view-collapse.collapse.navbar-collapse'

dropdown_entry = tc.renderable (entry) ->
  tc.a '.dropdown-toggle', role:'button', 'data-toggle':'dropdown', ->
    tc.text entry.label
    tc.b '.caret'
  tc.ul '.dropdown-menu', ->
    for link in entry.menu
      tc.li ->
        tc.a '.navbar-entry', href:link.url, link.label

single_entry = tc.renderable (entry) ->
  tc.a '.navbar-entry', href:entry.url, entry.label
      
class NavbarEntryView extends Marionette.View
  model: NavbarEntry
  tagName: 'li'
  className: ->
    if @model.has 'menu' then 'dropdown' else undefined
  template: tc.renderable (model) ->
    if model?.menu
      dropdown_entry model
    else
      single_entry model
  ui:
    entry: '.navbar-entry'
  triggers:
    'click @ui.entry': 'click:entry'
  set_active: ->
    @$el.addClass 'active'
  unset_active: ->
    @$el.removeClass 'active'
    # FIXME triggering click:entry
    # seems to leave dropdown open
    # this closes the navbar menu
    @$el.removeClass 'open'
    
    
class NavbarEntryCollectionView extends Marionette.CollectionView
  tagName: 'ul'
  className: 'nav navbar-nav nav-pills'
  childView: NavbarEntryView
  setAllInactive: ->
    @children.each (view) ->
      view.unset_active()
      
  onChildviewClickEntry: (cview, event) ->
    #console.log "HERE IS MORE STUFF", event
    @setAllInactive()
    cview.set_active()
    @navigateOnClickEntry cview, event
    
  navigateOnClickEntry: (cview, event) ->
    target = event.target
    # look at href and go there maybe?
    href = $(target).attr 'href'
    if href.split('/')[0] == ''
      window.location = href
    else
      router = MainChannel.request 'main-router'
      router.navigate href, trigger: true
      

class NavbarEntriesView extends Marionette.View
  regions:
    list: '#navbar-entries'
    userMenu: '#user-menu'
    search: '#form-search-container'
  onRender: ->
    view = new NavbarEntryCollectionView
      collection: @collection
    @showChildView 'list', view
  template: tc.renderable (model) ->
    tc.div '#navbar-view-collapse.collapse.navbar-collapse', ->
      tc.div '#navbar-entries'
      tc.ul '#user-menu.nav.navbar-nav.navbar-right'
      tc.div '#form-search-container'
  setAllInactive: ->
    view = @getChildView 'list'
    view.setAllInactive()
    
    
class NavbarHeaderView extends Marionette.View
  template: tc.renderable (model) ->
    navbar_collapse_button 'navbar-view-collapse'
    tc.a '.navbar-brand', href:model.url, model.label
  ui:
    brand: '.navbar-brand'
  triggers:
    'click @ui.brand': 'click:brand'
    
    
class BootstrapNavBarView extends Marionette.View
  template: tc.renderable (model) ->
    tc.nav '#navbar-view.navbar.navbar-static-top.navbar-default',
    xmlns:'http://www.w3.org/1999/xhtml', 'xml:lang':'en',
    role:'navigation', ->
      tc.div '.container', ->
        tc.div '.navbar-header'
        tc.div '#navbar-entries'
  regions:
    header: '.navbar-header'
    usermenu: '#user-menu'
    mainmenu: '#main-menu'
    entries: '#navbar-entries'
  onRender: ->
    eview = new NavbarEntriesView
      collection: new Backbone.Collection @model.get 'navbarEntries'
    @showChildView 'entries', eview
    hview = new NavbarHeaderView
      model: new Backbone.Model @model.get 'brand'
    @showChildView 'header', hview
    
  onChildviewClickBrand: (view, event) ->
    eview = @getChildView 'entries'
    eview.setAllInactive()
    @navigateOnClickEntry view, event
    
  navigateOnClickEntry: (cview, event) ->
    console.log "Brand clicked"
    target = event.target
    console.log "Target", target
    # look at href and go there maybe?
    href = $(target).attr 'href'
    if href.split('/')[0] == ''
      window.location = href
    else
      router = MainChannel.request 'main-router'
      router.navigate href, trigger: true
      

class NavbarApp extends Toolkit.App
  onBeforeStart: ->
    console.log 'NavbarApp options', @options
    appConfig = @options.appConfig
    region = @options.parentApp.getView().getRegion 'navbar'
    @setRegion region
    if appConfig.hasUser
      userMenuApp = @addChildApp 'user-menu',
        AppClass: appConfig.userMenuApp
        startWithParent: true
        appConfig: appConfig
        ,
        parentApp: @
        
  onStart: ->
    # build main page layout
    @initPage()

  initPage: ->
    appConfig = @options.parentApp.options.appConfig
    layout = new BootstrapNavBarView
      model: new Backbone.Model appConfig
    @showView layout

module.exports = NavbarApp


