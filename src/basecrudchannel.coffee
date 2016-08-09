Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

{ create_model
  get_model } = require './apputil'

make_dbclasses = (objname, url) ->
  modelClass = class DbModel extends Backbone.Model
    urlRoot: url
  collectionClass = class DbCollection extends Backbone.Model
    model: modelClass
    url: url
  return {
    modelClass: modelClass
    collectionClass: collectionClass }
    
make_dbchannel = (channel, objname, modelClass, collectionClass) ->
  collection = new collectionClass
  channel.reply "#{objname}-collection", ->
    collection
  channel.reply "new-#{objname}", ->
    new modelClass
  channel.reply "add-#{objname}", (options) ->
    create_model collection options
  channel.reply "get-#{objname}", (id) ->
    get_model collection, id
    

module.exports =
  make_dbclasses: make_dbclasses
  make_dbchannel: make_dbchannel
