// Generated by CoffeeScript 1.3.3
(function() {
  var Maker, cradle, types,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  types = require('./noxious_types.js');

  cradle = require('cradle');

  Maker = (function() {

    function Maker(settings) {
      this.save = __bind(this.save, this);

      this.create_instance = __bind(this.create_instance, this);

      this.handle = __bind(this.handle, this);

      this.register_template = __bind(this.register_template, this);

      this.destroy_db = __bind(this.destroy_db, this);

      this.create_db = __bind(this.create_db, this);
      this.settings = settings;
      this.templates = {};
      this.create_db(settings.name);
    }

    Maker.prototype.create_db = function(name) {
      var _this = this;
      this.connection = new cradle.Connection;
      this.db = this.connection.database(name);
      return this.db.exists(function(err, exists) {
        if (!exists) {
          return _this.db.create(function() {});
        }
      });
    };

    Maker.prototype.destroy_db = function() {
      var _this = this;
      return this.db.exists(function(err, exists) {
        if (exists) {
          return _this.db.destroy(function() {});
        }
      });
    };

    Maker.prototype.register_template = function(template_name, template, mapper) {
      return this.templates[template_name] = {
        template: new template,
        mapper: mapper
      };
    };

    Maker.prototype.handle = function(ret_val, template, key, source) {
      var map, template_field, v, val;
      template_field = template.template[key];
      ret_val.__type = template.template;
      if (template.mapper != null) {
        map = template.mapper[key];
      }
      if (map != null) {
        val = map(source(map instanceof Function ? void 0 : source[map]));
      }
      if ((source != null) && (source[key] != null)) {
        val = source[key];
      }
      if (!(val != null)) {
        val = template.template[key].default_value;
      }
      if (template_field.type === 'text') {
        ret_val[key] = val;
      }
      if (template_field.type === 'array') {
        ret_val[key] = (function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = val.length; _i < _len; _i++) {
            v = val[_i];
            _results.push(this.create_instance(template_field.item_template_name, v));
          }
          return _results;
        }).call(this);
      }
      if (template_field.type === 'ref') {
        return ret_val[key] = this.create_instance(template_field.item_template_name, val);
      }
    };

    Maker.prototype.create_instance = function(template_name, source) {
      var key, ret_val, template, template_keys, _i, _len,
        _this = this;
      ret_val = {};
      template = this.templates[template_name];
      template_keys = Object.keys(template.template);
      for (_i = 0, _len = template_keys.length; _i < _len; _i++) {
        key = template_keys[_i];
        this.handle(ret_val, template, key, source);
      }
      ret_val.save = function() {
        return _this.save( this);
      };
      return ret_val;
    };

    Maker.prototype.save = function(o) {};

    return Maker;

  })();

  module.exports.Maker = Maker;

}).call(this);
