# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'prestashop/version'

Gem::Specification.new do |spec|
  spec.name          = "prestashop"
  spec.version       = Prestashop::VERSION
  spec.authors       = ["JiriKolarik"]
  spec.email         = ["jiri.kolarik@imin.cz"]
  spec.description   = %q{Prestashop WebService API library}
  spec.summary       = %q{Prestashop WebService API library}
  spec.homepage      = "https://wereinhq.com/guides/prestashop"
  spec.license       = "NC"

  spec.files         = Dir["{lib}/**/*", "LICENSE.txt", "Rakefile", "README.md"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "sanitize", "~> 4.6.6"
  spec.add_dependency "faraday", "~> 1.0"
  spec.add_dependency "mini_magick", ">= 4.10.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "factory_girl"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "codeclimate-test-reporter"
end
