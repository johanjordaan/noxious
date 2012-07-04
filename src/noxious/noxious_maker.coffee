types = require './noxious_types.js'
cradle = require 'cradle'


class Maker
  constructor: (settings) -> 
    @settings = settings
    @templates = {}
    @create_db settings.name  

  create_db: (name)=>
    @connection = new (cradle.Connection)
    @db = @connection.database name
    @db.exists (err,exists) =>
      if not exists
        @db.create => 
        
  destroy_db: =>
    @db.exists (err,exists) =>
      if exists
        @db.destroy => 
        
  register_template: (template_name,template,mapper) =>
    @templates[template_name] =
      template: new template 
      mapper: mapper
  
  handle: (ret_val,template,key,source) =>
    template_field = template.template[key];

    ret_val.__type = template.template; 

    # Get the value, default,source, mapper
    #
    map = template.mapper[key] if template.mapper?
    val = (map source if map instanceof Function else source[map]) if map?
    val = source[key] if source? and source[key]? 
    val = template.template[key].default_value if not val?
    
    if template_field.type == 'text'
      ret_val[key] = val
    
    if template_field.type == 'array'
      ret_val[key] = (@create_instance template_field.item_template_name,v for v in val)

    if template_field.type == 'ref'
      ret_val[key] = @create_instance template_field.item_template_name,val
  
  create_instance: (template_name,source) =>
    ret_val = {}
    template = @templates[template_name]
    template_keys = Object.keys template.template
      
    @handle ret_val,template,key,source for key in template_keys  

    ret_val
 
module.exports.Maker = Maker  
