class TextField 
  constructor: (length,default_value) ->
    @type = 'text'
    @length = length
    @default_value = default_value ? ''
module.exports.TextField = TextField
    
class ArrayField
  constructor: (item_template_name) ->
    @type = 'array'
    @item_template_name = item_template_name
    @default_value = []
module.exports.ArrayField = ArrayField
  
class RefField
  constructor: (item_template_name) ->
    @type = 'ref'
    @item_template_name = item_template_name
    @default_value = {}
module.exports.RefField = RefField    
    
