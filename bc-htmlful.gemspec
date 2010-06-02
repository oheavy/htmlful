# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{bc-htmlful}
  s.version = "0.0.7.localtracker"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Duarte Henriques", "Vasco Andrade e Silva"]
  s.date = %q{2010-06-02}
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
     "javascripts/dynamic-fields.js",
     "javascripts/dynamic-fields.prototype.js",
     "lib/htmlful.rb",
     "lib/htmlful/dynamic_fields.rb",
     "rails/init.rb",
     "stylesheets/dynamic_fields.sass",
     "tasks/htmlful.rake"
  ]
  s.homepage = %q{http://github.com/Byclosure/}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Form dynamic fields}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

