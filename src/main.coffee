initpage = require './app-initpage'
app_prepare = require './app-prepare'
apputil = require './apputil'
router = require './bootstrap_router'
controllers = require './controllers'
regions = require './regions'
views = require './views'
users = require './users'
clipboard = require './clipboard'
messages = require './messages'
templates = require './templates/main'

module.exports =
  app:
    initpage: initpage
    prepare: app_prepare
  util: apputil
  router: router
  controllers: controllers
  regions: regions
  views: views
  users: users
  clipboard: clipboard
  messages: messages
  templates: templates
