// Generated by CoffeeScript 1.3.3
(function() {
  var Client, Gender, User, async, chai, expect, nox, path, should, types,
    _this = this;

  path = require('path');

  async = require('async');

  chai = require('chai');

  should = chai.should();

  expect = chai.expect;

  types = require('../noxious/noxious_types.js');

  nox = require('../noxious/noxious.js');

  User = (function() {

    function User() {
      this.__name = 'User';
      this.name = new types.TextField(10, 'johan');
      this.surname = new types.TextField(20);
      this.gender = new types.RefField('Gender');
    }

    return User;

  })();

  Gender = (function() {

    function Gender() {
      this.__name = 'Gender';
      this.label = new types.TextField(20);
    }

    return Gender;

  })();

  Client = (function() {

    function Client() {
      this.__name = 'XClient';
      this.__plural = 'XClientsss';
      this.name = new types.TextField(10);
      this.surname = new types.TextField(20);
    }

    return Client;

  })();

  describe('construct_class', function() {
    nox.construct_class('Gender', Gender);
    nox.construct_class('User', User);
    nox.construct_class('Client', Client);
    it('should create the new class in the namespace', function(done) {
      should.exist(nox.User);
      return done();
    });
    it('should create the new class in the namespace using the __name attribute', function(done) {
      should.exist(nox.XClient);
      return done();
    });
    it('should create a class and the type should be of type function', function(done) {
      expect(nox.User).to.be.a('Function');
      return done();
    });
    it('should create a function to load the objects of this type', function(done) {
      expect(nox.Users.load).to.be.a('Function');
      return done();
    });
    it('should create a function to load the objects of this type using the plural attribute', function(done) {
      expect(nox.XClientsss.load).to.be.a('Function');
      return done();
    });
    return it('should create a class with a save function', function(done) {
      var user;
      user = new nox.User();
      expect(user.save).to.be.a('Function');
      return done();
    });
  });

  describe('clear', function() {
    nox.construct_class('User', User);
    nox.construct_class('Client', Client);
    return it('should remove all the constructed classes from the imported module', function(done) {
      nox.clear();
      should.not.exist(nox.User);
      should.not.exist(nox.Users);
      should.not.exist(nox.CLient);
      should.not.exist(nox.CLients);
      should.not.exist(nox.XCLient);
      should.not.exist(nox.XCLients);
      return done();
    });
  });

  describe('init', function() {
    return it('should construct the classes specified in the files', function(done) {
      nox.clear();
      return nox.init({
        db_name: 'test',
        root_dir: path.resolve(),
        template_dirs: ['./test/data']
      }, function() {
        should.exist(nox.User);
        should.exist(nox.Users);
        should.exist(nox.XClient);
        should.exist(nox.XClientsss);
        return done();
      });
    });
  });

  describe('save', function() {
    return it('should save the class to the DB', function(done) {
      nox.clear();
      return nox.init({
        db_name: 'test',
        root_dir: path.resolve(),
        template_dirs: ['./test/data']
      }, function() {
        var u,
          _this = this;
        u = new nox.User;
        u.name = 'Johan';
        u.save(function() {
          return u.save(function() {
            return done();
          });
        });
        return nox.User.load();
      });
    });
  });

}).call(this);
