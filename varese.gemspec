# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'varese/version'

Gem::Specification.new do |spec|
  spec.name          = "varese"
  spec.version       = Varese::VERSION
  spec.authors       = ["zvkemp"]
  spec.email         = ["zvkemp@gmail.com"]
  spec.summary       = %q{This product uses the Census Bureau Data API but is not endorsed or certified by the Census Bureau.}
  spec.description   = %q{Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"

  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-minitest'
  spec.add_development_dependency 'minitest-reporters'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'rr'
end
