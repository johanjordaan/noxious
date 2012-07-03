UGLIFY_FLAGS = --no-mangle 

all: run 

#minify:  
#	@uglifyjs easyajaxforms.js > easyajaxforms-min.js
#	@cp easyajaxforms.js examples/public/javascripts/easyajaxforms.js

build: 
	@coffee -c -o . src

tests: build 
	@mocha  
  
run: run_tests
	@node app.js