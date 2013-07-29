module.exports = (app) ->

    AppConfig = require '../lib/app-config'
    appConfig = new AppConfig require('../lib/api-manager').reutilisateurID
    app.post '/save-ids', (req, res) ->

        params = req.body
        #console.log req
        appConfig.setConfig params, (err) ->
            if err?
                errorMsg = "An error occurred while setting the configuration."
                res.send 500, errorMsg, err
            else
                res.redirect 'back'

    app.get '/', (req, res) ->
        appConfig.getConfig (err, doc) ->
            unless doc?
                doc =
                    mustRegister: true
                    login: ''
                    password: ''
            else
                doc.mustRegister = false
            res.render 'index.ejs', conf: doc, (err, html) ->
                console.log err if err?
                res.send 200, html

