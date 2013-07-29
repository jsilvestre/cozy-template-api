Client = require('request-json').JsonClient
AppConfig = require '../lib/app-config'

module.exports = class ApiManager

    # configurez votre nom de réutilisateur
    # (doit être unique sur toute la plateforme, pas d'espace ou de caractère spéciaux)
    @reutilisateurID: 'skerou'

    # configurez votre domaine (ie: http://api.skerou.com/)
    apiHostname: 'http://localhost:9800/'

    # liez des callbacks aux événements qui vous intéressent
    events:
        'skerouconfig.update': 'onConfigChange'
        'user.update': 'onInterUpdate'

    api: null

    # Ne modifiez pas le 'constructor' sauf si vous savez ce que vous faites
    constructor: (@ds, callback) ->
        @api = new Client @apiHostname

        new AppConfig(ApiManager.reutilisateurID).getConfig (err, conf) =>
            @api.setBasicAuth conf.login, conf.password unless err?
            callback(err, conf)

    # Déclarez ici tous les callbacks dont vous avez besoin
    onConfigChange: (event, id, err, config) ->

        # Ne modifiez pas cette ligne sauf si vous savez ce que vous faites
        @api.setBasicAuth config.login, config.password unless err?
        # Ce callback est un bon moyen de détecter lorsque l'utilisateur enregistre
        # initialement ses identiants
        # Vous pouvez par exemple envoyer toutes les DATA déjà présentes
        @ds.post 'request/user/all/', {}, (err, response, docs) ->
            # err: contient une éventuelle erreur
            # docs: contient un array de chaines JSON représentant tous
            #       les doc du doctype souhaité
            # Votre requête HTTP ici

    onInterUpdate: (event, id, err, user) ->
        console.log "user update !"

        if err?
            console.log "onInterUpdate > #{err}"
        else
            @api.get 'test/', (err, response, body) ->
                console.log body


