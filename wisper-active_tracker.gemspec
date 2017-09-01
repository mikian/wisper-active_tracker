# coding: utf-8
$:.push File.expand_path('../lib', __FILE__)

require 'wisper/active_tracker/version'

Gem::Specification.new do |spec|
  spec.name          = 'wisper-active_tracker'
  spec.version       = Wisper::ActiveTracker::VERSION
  spec.authors       = ['Mikko Kokkonen']
  spec.email         = ['mikko@mikian.com']
  spec.summary       = 'Subscribe to changes on ActiveRecord models'
  spec.description   = 'Subscribe to changes on ActiveRecord models'
  spec.homepage      = 'https://github.com/mikian/wisper-active_tracker'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'wisper', '~> 2.0'
  spec.add_dependency 'activerecord', '>= 5.0.0'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'sqlite3'
end
