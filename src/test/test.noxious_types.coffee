chai = require 'chai'  
should = chai.should()  
expect = chai.expect

nt = require '../noxious/noxious_types.js' 

describe 'TextField',()=>
  describe '.constructor(length)',()=>
    it 'should ',(done) =>
      m = new nt.TextField 10
      m.length.should.equal 10
      m.default_value.should.equal ''
      done()
      
  describe '.constructor(length,default_value)',()=>
    it 'should ',(done) =>
      m = new nt.TextField 10,'test'
      m.length.should.equal 10
      m.default_value.should.equal 'test'
      done()
      
describe 'ArrayField',()=>
  describe '.constructor(item_template_name)',()=>
    it 'should ',(done) =>
      m = new nt.ArrayField 'template'
      m.item_template_name.should.equal 'template'
      expect(m.default_value).to.be.a 'Array'
      done()

describe 'RefField',()=>
  describe '.constructor(item_template_name)',()=>
    it 'should ',(done) =>
      m = new nt.RefField 'template'
      m.item_template_name.should.equal 'template'
      expect(m.default_value).to.be.a 'Object'
      done()
      
      