# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'f00px_scraper/version'

Gem::Specification.new do |spec|
  spec.name          = "f00px_scraper"
  spec.version       = F00pxScraper::VERSION
  spec.authors       = ["John Tajima"]
  spec.email         = ["manjiro@gmail.com"]
  spec.description   = %q{Gem to generate photographers list from 500px photo streams}
  spec.summary       = %q{Gem to generate photographers list from 500px photo streams}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  #spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.executables   = ['ScraperCLI']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "httparty"
  spec.add_dependency "thor"
end
