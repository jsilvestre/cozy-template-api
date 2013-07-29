realtimeInitializer = require 'cozy-realtime-adapter'
Client = require('request-json').JsonClient
ApiManager = require '../lib/api-manager'

module.exports = (server) ->

    ds = new Client 'http://localhost:9101/'

    if process.env.NODE_ENV is "production"
        ds.setBasicAuth process.env.NAME, process.env.TOKEN

    apiManager = new ApiManager ds, (err) ->

        # Déclenche une erreur tant que l'utilisateur n'a pas entré ses identifiants
        console.log "Watcher > #{err}" if err?

        watchedEvents = Object.keys apiManager.events
        realtime = realtimeInitializer server: server, watchedEvents

        callbackFactory = (event, callbackName) ->
            console.log "Event #{event} bound to #{callbackName}."
            realtime.on event, (event, id) ->
                ds.get "data/#{id}/", (err, response, body) ->
                    apiManager[callbackName].call(apiManager, event, id, err, body)

        for event, callbackName of apiManager.events
            callbackFactory(event, callbackName)
