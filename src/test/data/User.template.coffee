types = require '../../noxious/noxious_types.js' 

class User
  constructor: ->
    @name = 'User'
    @name = new types.TextField 10,'johan'
    @surname = new types.TextField 20

module.exports.User = User    