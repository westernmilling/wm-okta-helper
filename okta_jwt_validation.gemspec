# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'okta_jwt_validation/version'

Gem::Specification.new do |spec|
  spec.name          = 'okta_jwt_validation'
  spec.version       = OktaJwtValidation::VERSION

  spec.authors       = ['Jose C Fernandez']
  spec.email         = ['jfernandez@westernmilling.com']

  spec.summary       = 'Helper library for validating Okta jwt token.'
  spec.description   = 'Helper library for validating Okta jwt token.'
  spec.homepage      = 'https://github.com/westernmilling/okta-jwt-validation'
  spec.license       = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'json-jwt'
  spec.add_dependency 'jwt'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'rubocop', '~> 0.54.0'
  spec.add_development_dependency 'simplecov'
end
