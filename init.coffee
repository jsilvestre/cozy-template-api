async = require "async"

# Create all requests
module.exports = init = (callback) ->
    all = (doc) -> emit doc._id, doc

    prepareRequests = []
    async.series prepareRequests, (err, results) ->
        callback(err)

# so we can do "coffee init"
if not module.parent
    init (err) ->
        if err
            console.log "init failled"
            console.log err.stack
        else
            console.log "init success"