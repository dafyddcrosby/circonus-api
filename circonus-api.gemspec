# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'circonus-api/version'

Gem::Specification.new do |gem|
  gem.name          = "circonus-api"
  gem.version       = Circonus::Api::VERSION
  gem.authors       = ["Ben Marini"]
  gem.email         = ["bmarini@gmail.com"]
  gem.homepage      = "https://github.com/bmarini/circonus-api"
  gem.description   = %q{Ruby client for the Circonus API}
  gem.summary       = %q{Ruby client for the Circonus API}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_runtime_dependency "rest-client"
  gem.add_runtime_dependency "json"
end
