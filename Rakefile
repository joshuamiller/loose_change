require 'rubygems'
require 'bundler/setup'

require 'rake'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  Bundler.require(:test)
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

begin
  Bundler.require(:development)
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "loose_change"
    gemspec.summary = "ActiveModel-compliant CouchDB ORM"
    gemspec.email = "josh@joshinharrisburg.com"
    gemspec.homepage = "http://github.com/joshuamiller/loose_change"
    gemspec.authors = ["Joshua Miller"]
  end
rescue LoadError
  puts "Jeweler not available."
end

