# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dune/api/version'

Gem::Specification.new do |spec|
  spec.name          = 'dune-api'
  spec.version       = Dune::Api::VERSION
  spec.authors       = ['Pierre Legrand']
  spec.email         = ['legrand.work@gmail.com']
  spec.summary       = 'dune API'
  spec.description   = 'This is the implementation of Dune API from neighborly api'
  spec.homepage      = 'https://github.com/FromUte/dune-api'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency             'has_scope'
  spec.add_dependency             'kaminari'
  spec.add_dependency             'pundit'
  spec.add_dependency             'rails',       '~> 4.0'
  spec.add_dependency             'active_model_serializers', '~> 0.8.0'
  spec.add_development_dependency 'rake',        '~> 10.3'
  spec.add_development_dependency 'rspec-rails', '~> 3.0.0'
end
