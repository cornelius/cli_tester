# -*- encoding: utf-8 -*-
require File.expand_path("../lib/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "cli_tester"
  s.version     = CliTester::VERSION
  s.license     = 'MIT'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Cornelius Schumacher']
  s.email       = ['schumacher@kde.org']
  s.homepage    = "http://github.com/cornelius/cli_tester"
  s.summary     = "RSpec helpers for testing command line interfaces"
  s.description = "CliTester provides a set of RSpec helpers to test command line interfaces by running commands and checking output and exit codes."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "cli_tester"

  s.add_dependency "cheetah"

  s.add_development_dependency "rspec", "~>3"
  s.add_development_dependency "given_filesystem"

  s.files        = `git ls-files`.split("\n")
  s.require_path = 'lib'
end
