Backbone = require 'backbone'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'

class BaseMessage extends Backbone.Model
  defaults:
    level: 'info'
  
class BaseMessageCollection extends Backbone.Collection
  model: BaseMessage

main_message_collection = new BaseMessageCollection
MessageChannel.reply 'messages', ->
  main_message_collection

display_message = (msg, level, icon=false) =>
  message = new BaseMessage
    content: msg
    level: level
    icon: icon
  # FIXME make delay configurable
  delay = 6000
  unless level is 'danger'
    destroy = -> main_message_collection.remove message
    setTimeout destroy, delay
  main_message_collection.add message
  
MessageChannel.reply 'display-message', (msg, lvl='info', icon=false) =>
  console.warn 'icon', icon
  display_message msg, lvl, icon

for level in ['success', 'info', 'warning', 'danger', 'brand']
  do (level) ->
    MessageChannel.reply level, (msg, icon=false) =>
      display_message msg, level, icon
      

MessageChannel.reply 'delete-message', (model) =>
  main_message_collection.remove model

module.exports =
  BaseMessageCollection: BaseMessageCollection
  

