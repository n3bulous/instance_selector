# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'instance_selector/version'

Gem::Specification.new do |spec|
  spec.name          = "instance_selector"
  spec.version       = InstanceSelector::VERSION
  spec.authors       = ["Kevin McFadden"]
  spec.email         = ["kmcfadden@gmail.com"]
  spec.description   = %q{Retrieve cloud instance DNS names from metadata search}
  spec.summary       = %q{}
  spec.homepage      = "https://github.com/n3bulous/instance_selector"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


  spec.add_dependency "fog", "~> 1.4"
  spec.add_dependency('capistrano', '~> 2.1')
  spec.add_dependency('slop', '~> 3.4')


  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
