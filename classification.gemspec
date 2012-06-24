# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "classification"
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ryan Michael"]
  s.date = "2012-06-24"
  s.description = "Classifiers of various types for to make data useful"
  s.email = "kerinin@gmail.com"
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    ".travis.yml",
    "Gemfile",
    "README.md",
    "Rakefile",
    "VERSION",
    "classification.gemspec",
    "lib/classification.rb",
    "lib/classification/naive_bayes.rb",
    "lib/classification/version.rb",
    "python/analysis.py",
    "python/analysis.pyc",
    "python/array_tools.py",
    "python/array_tools.pyc",
    "python/bayes_classifier.py",
    "python/bayes_classifier.pyc",
    "python/combined_classifier.py",
    "python/combined_classifier.pyc",
    "python/compare_performance.py",
    "python/data.py",
    "python/data.pyc",
    "python/itembased_classifier.py",
    "python/itembased_classifier.pyc",
    "python/metric_analysis.py",
    "python/parse_yaml_for_classifier.py",
    "python/parse_yaml_for_itembased.py",
    "python/subset_classifier.py",
    "spec/spec_helper.rb",
    "tasks/environment.rake",
    "tasks/frequency.rake",
    "tasks/naive_bayes.rake",
    "test_gnuplot.rb"
  ]
  s.homepage = "http://github.com/kerinin/classification"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "We can classify that!"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<classification>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<gnuplot>, [">= 0"])
    else
      s.add_dependency(%q<classification>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<gnuplot>, [">= 0"])
    end
  else
    s.add_dependency(%q<classification>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<gnuplot>, [">= 0"])
  end
end
