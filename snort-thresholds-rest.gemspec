# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'snort-thresholds-rest'
  s.version = '1.0.0'
  #s.license = ''

  s.authors = ["seabeetea"]
  s.description = ""
  s.email = "seabeetea@users.noreply.github.com"

  s.files = %w(server.rb Rakefile README.md LICENSE CONTRIBUTING.md CHANGELOG.md)
  s.homepage = 'http://github.com/seabeetea/snort-thresholds-rest'
  s.rdoc_options = ["--charset=UTF-8"]
  #s.require_paths = ["lib"]
  s.summary = %q{}
  s.test_files = Dir.glob("test/*")

  s.required_ruby_version = '>= 1.9.3'

  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.1'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'codeclimate-test-reporter'
end
