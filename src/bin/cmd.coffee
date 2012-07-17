path = require 'path'
fs = require 'fs'
ejs = require 'ejs'
program = require 'commander'
pkg = require '../package.json'
os = require 'os'
winston = require 'winston'

version = pkg.version
eol = if 'win32' == os.platform() then '\r\n'  else '\n'

# Logging setup
#
log = new (winston.Logger)
  transports: [
    new winston.transports.Console
      level:'error'
  ]

log_verbose = (option) =>
  if option == true
    log.transports.console.level = 'info'

# The actual commands
#
settings_template = [
   "module.exports = "
  ," name : '<%= project_name %>'"
].join(eol);

start_project = (project_name,options) =>
  log_verbose(options.verbose)
  log.info('Starting new project ['+project_name+'].');
  project_path = path.join('.',project_name);
  path.exists project_path,(exists) =>
    if exists 
      throw '['+project_name+'] already exists'
    fs.mkdirSync(project_path);
    fs.mkdirSync(path.join(project_path,'src'));
    fs.writeFileSync(path.join(project_path,'src','settings.coffee'),ejs.render(settings_template,{project_name:project_name}));

# Setup the command line
#
program
  .usage('[options] <settings>')
  .version(version)
  
program
  .command('startproject <project_name>')
  .description(' starts a new noxious project')
  .option('-v, --verbose','Switch verbose status reporing on')
  .action(start_project);

program.parse(process.argv);
  
  
  
    