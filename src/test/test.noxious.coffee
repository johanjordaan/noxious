chai = require 'chai'  
should = chai.should()  
expect = chai.expect

types = require '../noxious/noxious_types.js' 
nox = require '../noxious/noxious.js' 

class User
  constructor: ->
    @name = new types.TextField 10
    @surname = new types.TextField 20

describe 'construct_class',()=>
  nox.construct_class('User',User)

  it 'should create the new class in the namespace',(done) =>
    should.exist(nox.User)
    done()

  it 'should create a class and the type should be of type function',(done) =>
    expect(nox.User).to.be.a('Function')
    done()  

  it 'should create a class with a save function',(done) =>
    user = new nox.User()
    expect(user.save).to.be.a('Function')
    done()

  it 'should create a function to load the objects of this type',(done) =>
    expect(nox.Users.load).to.be.a('Function')
    done()
    
    
    
    