// Generated by CoffeeScript 1.3.3
(function() {
  var User, chai, expect, nox, should, types,
    _this = this;

  chai = require('chai');

  should = chai.should();

  expect = chai.expect;

  types = require('../noxious/noxious_types.js');

  nox = require('../noxious/noxious.js');

  User = (function() {

    function User() {
      this.name = new types.TextField(10);
      this.surname = new types.TextField(20);
    }

    return User;

  })();

  describe('construct_class', function() {
    nox.construct_class('User', User);
    it('should create the new class in the namespace', function(done) {
      should.exist(nox.User);
      return done();
    });
    it('should create a class and the type should be of type function', function(done) {
      expect(nox.User).to.be.a('Function');
      return done();
    });
    it('should create a class with a save function', function(done) {
      var user;
      user = new nox.User();
      expect(user.save).to.be.a('Function');
      return done();
    });
    return it('should create a function to load the objects of this type', function(done) {
      expect(nox.Users.load).to.be.a('Function');
      return done();
    });
  });

}).call(this);
