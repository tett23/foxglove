# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'foxglove/version'

Gem::Specification.new do |spec|
  spec.name          = "foxglove"
  spec.version       = Foxglove::VERSION
  spec.authors       = ["tett23"]
  spec.email         = ["tett23@gmail.com"]
  spec.description   = %q{Static pages CMS}
  spec.summary       = %q{Static pages CMS}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'thor'
  spec.add_dependency 'haml'
  spec.add_dependency 'RedCloth'
  spec.add_dependency 'i18n'
  spec.add_dependency 'active_support'
  spec.add_dependency 'sass'
  spec.add_dependency 'coffee-script'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
