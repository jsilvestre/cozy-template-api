module.exports = class AppConfig

    constructor: (@reuName) ->
        Schema = require('jugglingdb').Schema
        settings = url: 'http://localhost:9101/'
        @db = new Schema 'cozy-adapter', settings

    getModel: (reuName) ->
        Model = @db.define @reuName + 'Config',
           id            : String
           config        : Object

    setConfig: (config, cb) ->
        model = @getModel @reuName

        map = (doc) -> emit doc.id, doc
        model.defineRequest 'all', map, (err) ->
            return cb err if err

        model.request 'all', (err, docs) ->
            return cb err if err

            if docs.length
                docs[0].updateAttributes config: config, cb
            else
                model.create config: config, cb

    getConfig: (cb) ->
        @getModel(@reuName).request 'all', (err, docs) ->
            return cb err, docs?[0]?.config