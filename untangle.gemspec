# -*- encoding: utf-8 -*-
require File.expand_path('../lib/untangle/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Yves Senn"]
  gem.email         = ["yves.senn@gmail.com"]
  gem.description   = 'Leightweight dependency API for your POROs'
  gem.summary       = 'ungangle your dependencies mess and make them visible.'
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "untangle"
  gem.require_paths = ["lib"]
  gem.version       = Untangle::VERSION

  gem.add_dependency 'activesupport', '>= 3.0'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
end
