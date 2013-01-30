# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "slim-api-ruby"
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ondrej Bartas"]
  s.date = "2013-01-30"
  s.description = "Wrapper over REST api of Ataxo - enables you to find, create, update and destroy objects"
  s.email = "ondrej@bartas.cz"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.markdown"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "LICENSE.txt",
    "README.markdown",
    "Rakefile",
    "VERSION",
    "lib/slim-api-ruby.rb",
    "lib/slim-api/objects/campaign.rb",
    "lib/slim-api/objects/category.rb",
    "lib/slim-api/objects/client.rb",
    "lib/slim-api/objects/contract.rb",
    "lib/slim-api/objects/course.rb",
    "lib/slim-api/objects/import_campaign_statistics.rb",
    "lib/slim-api/objects/import_keyword_statistics.rb",
    "lib/slim-api/objects/statistics.rb",
    "lib/slim-api/objects/user.rb",
    "lib/slim-api/slim_api.rb",
    "lib/slim-api/slim_array.rb",
    "lib/slim-api/slim_object.rb",
    "slim-api-ruby.gemspec",
    "test/helper.rb",
    "test/test_slim-api.rb"
  ]
  s.homepage = "http://github.com/Ataxo/slim-api-ruby"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Easier access Ataxo Slim Api service"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<curb>, [">= 0"])
      s.add_runtime_dependency(%q<yajl-ruby>, [">= 0"])
      s.add_runtime_dependency(%q<hashr>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
    else
      s.add_dependency(%q<curb>, [">= 0"])
      s.add_dependency(%q<yajl-ruby>, [">= 0"])
      s.add_dependency(%q<hashr>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
    end
  else
    s.add_dependency(%q<curb>, [">= 0"])
    s.add_dependency(%q<yajl-ruby>, [">= 0"])
    s.add_dependency(%q<hashr>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
  end
end

