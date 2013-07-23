http = require 'http'
express = require 'express'
init = require './init'
watcher = require './server/services/watcher'
configure = require './server/config'
handleRequests = require './server/controllers/main'

module.exports = app = express()
configure(app)
handleRequests(app)

if not module.parent
    init (err) -> # ./init.coffee
        if err
            console.log "Initialization failed, not starting"
            console.log err.stack
            return

        port = process.env.PORT or 9260
        host = process.env.HOST or "127.0.0.1"
        server = http.createServer(app).listen port, host, ->
            console.log "Server listening on %s:%d within %s environment",
                host, port, app.get('env')

            watcher(server)