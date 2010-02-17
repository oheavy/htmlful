# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{bc-htmlful}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Duarte Henriques", "Vasco Andrade e Silva"]
  s.date = %q{2010-02-15}
  s.description = %q{Form dynamic fields}
  s.email = %q{info@byclosure.com}
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    ".gitignore",
     "README",
     "Rakefile",
     "VERSION",
     "bc-htmlful.gemspec",
     "javascripts/dynamic_fields.js",
     "javascripts/dynamic_fields.prototype.js",
     "lib/htmlful.rb",
     "lib/htmlful/dynamic_fields.rb",
     "rails/init.rb",
     "stylesheets/dynamic_fields.sass"
  ]
  s.homepage = %q{http://github.com/Byclosure/}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Form dynamic fields}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end