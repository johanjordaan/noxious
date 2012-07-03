chai = require 'chai'  
should = chai.should()  
expect = chai.expect

nt = require '../noxious/noxious_types.js' 
nm = require '../noxious/noxious_maker.js' 

# Start of the test support stuff
#
class User
  constructor: ->
    @name = new nt.TextField 20
    @surname = new nt.TextField 30
    @accounts = new nt.ArrayField 'Account'

class Account
  constructor: ->
    @number = new nt.TextField 10

settings = 
  name : 'test'
  
# Strat of the actual tests
#    
describe 'Maker',()=>
  m = new nm.Maker settings
  after (done) =>
    m.destroy_db 
    done()

  describe '.constructor()',()=>
    it 'should construct a maker object',(done) =>
      expect(m.templates).to.be.a 'Object' 
      done()
      
  describe '.register_template(template_name,template,mapper)',()=>
    m = new nm.Maker settings
    m.register_template('user',User)
    keys = Object.keys(m.templates)

    after (done) =>
      m.destroy_db
      done()
    
    it 'should register only the template specified',(done) =>
      keys.length.should.equal 1
      done()
      
    it 'should add the template with the specidfied key',(done) =>
      keys[0].should.equal 'user'
      done()

    it 'should add the correct type for the specified key',(done) =>
      (m.templates['user'].template instanceof User).should.equal(true);
      done()
   
    it 'should not add a mapper if it wasnt specified',(done) =>
      should.not.exist m.templates['user'].mapper
      done()

    it 'should add extra templates',(done) =>
      m.register_template 'user2',User,(i) =>
        i  
      keys = Object.keys(m.templates)
      keys.length.should.equal 2
      done()
    
    it 'should add a mapper if specified',(done) =>
      expect(m.templates['user2'].mapper).to.be.a 'Function' 
      done()

  describe '.create_instance(template_name,source)',()=>
    m = new nm.Maker settings
    m.register_template 'User',User
    m.register_template 'Account',Account

    after (done) =>
      m.destroy_db 
      done()
    
    it 'should create a default instance of the type specified if no source is specified',(done) =>
      o = m.create_instance 'User'
      o.name.should.equal ''
      o.surname.should.equal ''
      expect(o.accounts).to.be.a 'Array'
      o.accounts.length.should.equal 0
      done()

    it 'should create an instance of the type specified and populate it with the data from the source',(done) =>
      o = m.create_instance 'User',
              name: 'johan'
              surname: 'jordaan'
              accounts: [
                { number: '123' }
                { number: '321' }
              ]
      console.log 
      o.name.should.equal 'johan'
      o.surname.should.equal 'jordaan'
      o.accounts.length.should.equal 2
      x = (account for account in o.accounts)
      ((account.__type instanceof Account).should.equal true) for account in o.accounts 
      done()
      
      
      
  describe '.save()',()=>
    m = new nm.Maker settings
    after (done) =>
      m.destroy_db 
      done()
  
    it 'should save',(done) =>
      m.register_template 'User',User
      m.register_template 'Account',Account
      done()
      