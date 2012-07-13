class X
  constructor:->
    console.log 'Hallo'
    
X.load = () ->
  console.log 'Loading ...'
    
#x = new X
X.load()