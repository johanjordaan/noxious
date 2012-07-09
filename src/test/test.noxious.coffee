path = require 'path'

chai = require 'chai'  
should = chai.should()  
expect = chai.expect

types = require '../noxious/noxious_types.js' 
nox = require '../noxious/noxious.js' 

class User
  constructor: ->
    @name = new types.TextField 10
    @surname = new types.TextField 20

class Client
  constructor: ->
    @__name = 'XClient'
    @__plural = 'XClientsss'
    @name = new types.TextField 10
    @surname = new types.TextField 20    
    
    
# construct_class
#
describe 'construct_class',()=>
  nox.construct_class('User',User)
  nox.construct_class('Client',Client)

  
  it 'should create the new class in the namespace',(done) =>
    should.exist(nox.User)
    done()

  it 'should create the new class in the namespace using the __name attribute',(done) =>
    should.exist(nox.XClient)
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

  it 'should create a function to load the objects of this type using the plural attribute',(done) =>
    expect(nox.XClientsss.load).to.be.a('Function')
    done()
   
    
# clear
#
describe 'clear',()=>
  nox.construct_class('User',User)
  nox.construct_class('Client',Client)
  
  it 'should remove all the constructed classes from the imported module',(done) =>
    nox.clear()
    should.not.exist(nox.User)
    should.not.exist(nox.Users)
    should.not.exist(nox.CLient)
    should.not.exist(nox.CLients)
    should.not.exist(nox.XCLient)
    should.not.exist(nox.XCLients)
    done()
    
# init
#
describe 'init',()=>
  it 'should construct the classes specified in the files',(done) =>
    nox.clear()
    nox.init
      root_dir : path.resolve()
      template_dirs : ['./test/data']
    should.exist(nox.User)  
    should.exist(nox.Users) 
    should.exist(nox.XClient)  
    should.exist(nox.XClientsss) 
    done()
