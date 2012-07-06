fs = require 'fs'
path =  require 'path'

templates = []

construct_class = (name,template) =>
  # Create the class in the module namespace
  module.exports[name] = ()->
    @save = ()=>
      console.log 'Saving ...'
    undefined    
  
  # Create the load method in the module namespace for this
  module.exports[name+'s'] = 
    load : () ->
      console.log 'Loading ...'
  
module.exports.construct_class = construct_class
  
add_template = (template) =>
  templates[template.__name] = template

load_template_file = (file) =>
  tmp = require './'+file
  add_template(template) for template in Object.keys(tmp)

load_template_dir = (dir) =>
  # List the files in the directory
  files = fs.readdirSync dir
  
  # then for each one of the files load the templates
  load_template_file(file) for file in files
  

module.exports.init = (settings) =>
  # Load all the template directories
  load_template_dir(dir) for dir in settings.template_dirs
    
  # Create a new  
  construct_class(key,templates[key]) for key in Object.keys(templates)
  