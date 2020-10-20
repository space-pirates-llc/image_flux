
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'image_flux/version'

Gem::Specification.new do |spec|
  spec.name          = 'image_flux'
  spec.version       = ImageFlux::VERSION
  spec.authors       = ['Sho Kusano']
  spec.email         = ['sho-kusano@space-pirates.jp']

  spec.summary       = 'URL builder for ImageFlux'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/space-pirates-llc/image_flux'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '>= 1.16'
  spec.add_development_dependency 'ffaker'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'coveralls'
end
