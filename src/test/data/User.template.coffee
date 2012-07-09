types = require '../../noxious/noxious_types.js' 

class User
  constructor: ->
    @name = new types.TextField 10
    @surname = new types.TextField 20

module.exports.User = User    