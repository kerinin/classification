# -*- encoding: utf-8 -*-
require File.expand_path('../lib/pest/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ryan Michael"]
  gem.email         = ["kerinin@gmail.com"]
  gem.description   = %q{Classifiers of various types for to make data useful}
  gem.summary       = %q{We can classify that!}
  gem.homepage      = "http://github.com/kerinin/classification"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "classification"
  gem.require_paths = ["lib"]
  gem.version       = Classification::VERSION

  gem.add_dependency 'narray'
  gem.add_dependency 'pest'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'gnuplot'
end
