module.exports = (app) ->

    express   = require 'express'

    # all environements
    app.configure ->
        app.use express.bodyParser
            keepExtensions: true

        app.set 'views', __dirname + '/../client'
        app.engine '.html', require('ejs').renderFile

        # static middleware
        app.use express.static __dirname + '/../client/public',
            maxAge: 86400000

    #development environement
    app.configure 'development', ->
        app.use express.logger 'dev'
        app.use express.errorHandler
            dumpExceptions: true
            showStack: true

    #production environement
    app.configure 'production', ->
        app.use express.logger()
        app.use express.errorHandler
            dumpExceptions: true
            showStack: true
