# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wisper/active_tracker/version'

Gem::Specification.new do |spec|
  spec.name          = "wisper-active_tracker"
  spec.version       = Wisper::ActiveTracker::VERSION
  spec.authors       = ["Mikko Kokkonen"]
  spec.email         = ["mikko@mikian.com"]
  spec.summary       = %q{Subscribe to changes on ActiveRecord models}
  spec.description   = %q{Subscribe to changes on ActiveRecord models}
  spec.homepage      = "https://github.com/mikian/wisper-active_tracker"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 1.9.3"

  spec.add_dependency "wisper", "~> 1.3"
  spec.add_dependency "activerecord", ">= 3.0.0"
end
