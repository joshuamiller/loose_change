# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{loose_change}
  s.version = "0.3.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Joshua Miller"]
  s.date = %q{2010-12-16}
  s.email = %q{josh@joshinharrisburg.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]
  s.files = [
    ".gitignore",
     "Gemfile",
     "Gemfile.lock",
     "LICENSE",
     "README.md",
     "Rakefile",
     "VERSION",
     "lib/loose_change.rb",
     "lib/loose_change/attachments.rb",
     "lib/loose_change/attributes.rb",
     "lib/loose_change/base.rb",
     "lib/loose_change/database.rb",
     "lib/loose_change/errors.rb",
     "lib/loose_change/helpers.rb",
     "lib/loose_change/naming.rb",
     "lib/loose_change/pagination.rb",
     "lib/loose_change/persistence.rb",
     "lib/loose_change/server.rb",
     "lib/loose_change/views.rb",
     "loose_change.gemspec",
     "test/attachment_test.rb",
     "test/attributes_test.rb",
     "test/base_test.rb",
     "test/callback_test.rb",
     "test/inheritance_test.rb",
     "test/pagination_test.rb",
     "test/persistence_test.rb",
     "test/resources/couchdb.png",
     "test/test_helper.rb",
     "test/view_test.rb"
  ]
  s.homepage = %q{http://github.com/joshuamiller/loose_change}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{ActiveModel-compliant CouchDB ORM}
  s.test_files = [
    "test/attachment_test.rb",
     "test/attributes_test.rb",
     "test/base_test.rb",
     "test/callback_test.rb",
     "test/inheritance_test.rb",
     "test/pagination_test.rb",
     "test/persistence_test.rb",
     "test/test_helper.rb",
     "test/view_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, ["~> 3.0.0"])
      s.add_runtime_dependency(%q<activemodel>, ["~> 3.0.0"])
      s.add_runtime_dependency(%q<rest-client>, ["~> 1.6.0"])
      s.add_runtime_dependency(%q<json>, ["~> 1.4.6"])
    else
      s.add_dependency(%q<activesupport>, ["~> 3.0.0"])
      s.add_dependency(%q<activemodel>, ["~> 3.0.0"])
      s.add_dependency(%q<rest-client>, ["~> 1.6.0"])
      s.add_dependency(%q<json>, ["~> 1.4.6"])
    end
  else
    s.add_dependency(%q<activesupport>, ["~> 3.0.0"])
    s.add_dependency(%q<activemodel>, ["~> 3.0.0"])
    s.add_dependency(%q<rest-client>, ["~> 1.6.0"])
    s.add_dependency(%q<json>, ["~> 1.4.6"])
  end
end

