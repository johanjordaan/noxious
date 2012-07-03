maker = require './maker.js'

# This is config stuff that needs to move out of here
#
tables = 
  users : 
    name      : 'users'
    type      : 'user'
    list_def  : 
      __list_fields : [ 'name','surname' ] 
    data      : []
    form      : 'user'

forms =
  user : 
    type      : 'user'

user = 
  name : new maker.TextField 30
  surname : new maker.TextField 50


m = new maker.Maker
m.register_template 'user',user
tables.users.data = m.convert([{name:'johan',surname:'jordaan'},{name:'lorraine',surname:'evert'}]).to 'user'

# The core stuff below ...
#

post_form = (req,res) =>
  console.log 'Posting stuff'
  res.render 'noxious/index', 
    title: 'noxious'

get_form = (req,res) =>
  form_name = req.params.form
  form = forms[form_name]
  
  if(req.xhr)
    res.partial 'noxious/form',
      form:form 
  else 
    res.render 'noxious/form', 
      form:form   

landing_page = (req, res) =>
  res.render 'noxious/index', 
    title: 'noxious'


table = (req,res) =>
  table_name = req.params.table;
  table = tables[table_name];
 
  if(req.xhr)
    res.partial 'noxious/table'
      table:table
  else 
    res.render 'noxious/table',
      table:table

module.exports = (app) =>
  app.get '/noxious', landing_page
  app.get '/noxious/table/:table', table
  app.get '/noxious/form/:form',get_form
  app.post '/noxious/form',post_form

