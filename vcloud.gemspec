# -*- encoding: utf-8 -*-
require File.expand_path('../lib/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Brian McClain", "Zach Robinson"]
  gem.description   = %q{vCloud Director API Ruby Bindings}
  gem.summary       = gem.summary
  gem.homepage      = "https://github.com/DieboldInc/vcloud-ruby"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "vcloud"
  gem.require_paths = ["lib"]
  gem.version       = VCloud::VERSION

  gem.required_ruby_version = '>= 1.9.1'

  gem.add_dependency "rest-client"
  gem.add_dependency 'nokogiri-happymapper'
end