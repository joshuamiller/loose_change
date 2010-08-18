require 'rubygems'
require 'bundler/setup'

require 'rake'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  Bundler.require(:test)
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
