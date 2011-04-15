require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/rdoctask'
require 'rspec/core/rake_task'

CLEAN.include('**/*.gem')

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "jah"
    gem.summary = "Be omnipresent..."
    gem.description = "Talk to your machines. Like a God."
    gem.email = "x@nofxx.com"
    gem.homepage = "http://github.com/nofxx/jah"
    gem.authors = ["Marcos Piccinini"]
    gem.add_dependency "capistrano"
    gem.add_dependency "blather"
    gem.add_dependency "i18n"
    gem.add_development_dependency "rspec"
    # gem.add_development_dependency "rr"
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end


desc "Runs spec suite"
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/*_spec.rb'
  spec.rspec_opts = ['--backtrace --colour']
end

task :default => :spec

begin
  require 'reek/rake_task'
  Reek::RakeTask.new do |t|
    t.fail_on_error = true
    t.verbose = false
    t.source_files = 'lib/**/*.rb'
  end
rescue LoadError
  task :reek do
    abort "Reek is not available. In order to run reek, you must: sudo gem install reek"
  end
end

begin
  require 'roodi'
  require 'roodi_task'
  RoodiTask.new do |t|
    t.verbose = false
  end
rescue LoadError
  task :roodi do
    abort "Roodi is not available. In order to run roodi, you must: sudo gem install roodi"
  end
end


require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "jah #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
