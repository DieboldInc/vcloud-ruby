# -*- encoding: utf-8 -*-
require File.expand_path('../lib/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Brian McClain", "Zach Robinson"]
  gem.description   = %q{vCloud Director API Ruby Bindings}
  gem.summary       = gem.summary
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "vcloud"
  gem.require_paths = ["lib"]
  gem.version       = VCloud::VERSION
  
  gem.add_dependency "rest-client"
end