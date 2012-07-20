UGLIFY_FLAGS = --no-mangle 

all: run 

#minify:  
#	@uglifyjs easyajaxforms.js > easyajaxforms-min.js
#	@cp easyajaxforms.js examples/public/javascripts/easyajaxforms.js

clean:
	@rm -Rf bin

build: clean
	@coffee -c -o . src
	@node bin/xcp.js src '*.ejs' .
	@node bin/xcp.js src '*.js' .

tests: build 
	@mocha  
  
run: run_tests
	@node app.js