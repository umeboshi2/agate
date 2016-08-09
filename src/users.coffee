Backbone = require 'backbone'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'

class User extends Backbone.Model

class CurrentUser extends User

make_current_user_model = (url) ->
  user= new CurrentUser
  user.url = url
  return user
  
MainChannel.reply 'create-current-user-object', (url) ->
  currentuser = make_current_user_model url
  # create current-user request
  MainChannel.reply 'current-user', ->
    currentuser
  MainChannel.reply 'update-user-config', (config) ->
    currentuser.set 'config', config
    response = currentuser.save()
    response.done =>
      currentuser
    response.fail =>
      MessageChannel.request 'danger', 'failed to update user config!'
  currentuser
  

module.exports =
  User: User
  CurrentUser: CurrentUser
  

