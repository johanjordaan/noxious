fs = require 'fs'
path =  require 'path'

constructed_artifacts = []

clear = () =>
  delete module.exports[cls] for cls in constructed_artifacts
  constructed_artifacts = []

construct_class_field = (cls,key,field) =>
  if field.type == 'text'
    cls[key] = field.default_value ? ''

  if field.type == 'ref'
    cls[key] = new module.exports[field.item_template_name]
    
construct_class = (default_name,template) =>
  # Create an instance of the template sothat we can utilise its innards like __xxx
  #
  template_instance = new template
  name = template_instance.__name ? default_name
  plural = template_instance.__plural ? name+'s' 
  
  # Create the class in the module namespace
  #
  constructed_artifacts.push(name)
  module.exports[name] = ()->
    construct_class_field(@,key,template_instance[key]) for key in Object.keys(template_instance)
    @save = ()=>
      console.log 'Saving ...'
    undefined    
  
  # Create the load method in the module namespace for this class
  #
  constructed_artifacts.push(plural)
  module.exports[plural] = 
    load : () ->
      console.log 'Loading ...'

construct_classes_from_file = (file) =>
  tmp = require file
  construct_class(key,tmp[key]) for key in Object.keys(tmp)

construct_classes_from_dir = (dir) =>
  construct_classes_from_file(path.join(dir,file)) for file in fs.readdirSync dir
  
init = (settings) =>
  construct_classes_from_dir(path.join(settings.root_dir,dir)) for dir in settings.template_dirs
  
module.exports.clear = clear
module.exports.construct_class = construct_class
module.exports.init = init  
  
  
  
  