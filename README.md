noxious
=======
1. Install noxious
```
npm install noxious -g
```

2. Create a new project
```
noxious startproject blog && cd blog
```

3. Install the project dependencies
```
npm install -d
```


```
\<project>
    \node_modules
    \noxious
    \public
    \views
    \routes
    \test
    
    
    
    \src
      \models     *.model.coffee
      \test       test.*.coffee
      \routes     *.coffee
    
```

4. Create create a new class template (src/templates/post.template.coffee)
```
types = require 'noxious_types' 

class Post
  constructor: ->
    @subject = new types.TextField 50
    @text = new types.TextField 1000
```

5. Run the dev server 
```
make runserver
```

6. Navigate to http://localhost:3003/noxious/

Thats it to get the basic site up and running.