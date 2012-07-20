fs = require 'fs'
path =  require 'path'
cradle = require 'cradle'
async = require 'async'
ejs = require 'ejs'

constructed_artifacts = []

clear = () =>
  delete module.exports[cls] for cls in constructed_artifacts
  constructed_artifacts = []

construct_class_field = (cls,key,field) =>
  if field.type == 'text'
    cls[key] = field.default_value ? ''

  if field.type == 'ref'
    cls[key] = new module.exports[field.item_template_name]
    
construct_db_field = (dest,key,field,source) =>
  if field.type == 'text'
    dest[key] = source[key]

construct_db_field_query = (dest,key,field,source) =>
  if field.type == 'text'
    dest[key] = (doc) ->
      if doc.resource == field.name && doc[key] == source[key]
        emit doc.id,doc

        
construct_class_file = (template_file_name,default_name,template) =>
  t = """require '<%= template_file_name %>'
  # hallo
  class <%= name %>
    constructor: ->  
  
  """ 
  params = {}
  
  # Create an instance of the template sothat we can utilise its innards like __xxx
  #
  params.template_file_name = template_file_name
  params.template_instance = new template
  params.name = params.template_instance.__name ? default_name
  params.plural = params.template_instance.__plural ? params.name+'s' 

  # Open file
  # Require template file
  # Define class  
  #console.log ejs.render(t,params)      
    
construct_class = (default_name,template) =>
  # Create an instance of the template sothat we can utilise its innards like __xxx
  #
  template_instance = new template
  name = template_instance.__name ? default_name
  plural = template_instance.__plural ? name+'s' 

  # Create the class views in the db
  #
  db_view = {}
  construct_db_field(db_view,key,template_instance[key],@) for key in Object.keys(template_instance)
  
  # Create the class in the module namespace
  #
  constructed_artifacts.push(name)
  module.exports[name] = ()->
    @__name = name
    @template_instance = template_instance
    construct_class_field(@,key,template_instance[key]) for key in Object.keys(template_instance)
    @save = (callback)=>
      # console.log @
      db_val = {} 
      db_val.resource = @__name
      construct_db_field(db_val,key,template_instance[key],@) for key in Object.keys(template_instance)
      if @__id
        # console.log 'Merge',@__id
        db.merge @__id,db_val, (err,res)=>
          if err
            console.log '---',err,res
          else
            @__id = res.id
          callback()
      else
        # console.log 'Save'
        db.save db_val, (err,res)=>
          if err
            console.log '---',err,res
          else
            @__id = res.id
          callback()
      undefined 
    undefined    
  
  module.exports[name].load = (id) =>
    #console.log 'Loading ...',id
  
  # Create the load method in the module namespace for this class
  #
  constructed_artifacts.push(plural)
  module.exports[plural] = 
    load : () ->
      #console.log 'Loading ...'

construct_classes_from_file = (file) =>
  tmp = require file
  construct_class(key,tmp[key]) for key in Object.keys(tmp)
  construct_class_file(file,key,tmp[key]) for key in Object.keys(tmp)

  
construct_classes_from_dir = (dir) =>
  construct_classes_from_file(path.join(dir,file)) for file in fs.readdirSync dir

db = undefined    
init = (settings,callback) =>
  # Create the db if it does not exist
  #
  c = new(cradle.Connection)()
  db = c.database('test') 
  
  async.series [
    # First call the db create. This will create the db if it does not exist and fail silently 
    # if the db already exists
    #
    (acallback) -> 
      db.create () ->
        acallback(null,null)
    # Then construct the classes
    #
    (acallback) ->
      construct_classes_from_dir(path.join(settings.root_dir,dir)) for dir in settings.template_dirs
      acallback(null,null)
  ],()->
    callback()
  
  
module.exports.clear = clear
module.exports.construct_class = construct_class
module.exports.init = init  
  
  
  
  