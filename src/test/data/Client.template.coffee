types = require '../../noxious/noxious_types.js' 

class Client
  constructor: ->
    @__name = 'XClient'
    @__plural = 'XClientsss'
    @name = new types.TextField 10
    @surname = new types.TextField 20   

module.exports.Client = Client    