# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fus/version'

Gem::Specification.new do |spec|
  spec.name          = "fus"
  spec.version       = Fus::VERSION
  spec.authors       = ["tsabend"]
  spec.email         = ["tsabend@gmail.com"]
  spec.summary       = %q{A tool for finding unused swift classes in an xcode project}
  spec.description   = %q{Coming soon}
  spec.homepage      = ""
  spec.license       = "MIT"
  spec.bindir        = 'bin'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency(%q<thor>, [">= 0"])
  spec.add_development_dependency "bundler", "~> 1.11.2"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
