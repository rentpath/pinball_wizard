# -*- encoding: utf-8 -*-
require File.expand_path('../lib/pinball_wizard/version', __FILE__)
require 'date'

Gem::Specification.new do |gem|
  gem.authors       = ["Caleb Wright", "Mark Herman", "RentPath Team"]
  gem.email         = ["cwright@rentpath.com", "markherman@rentpath.com"]
  gem.homepage      = 'https://github.com/primedia/pinball_wizard'
  gem.description   = 'Build flippable features.'
  gem.summary       = "Lib to build flippable features."
  gem.date          = Date.today.to_s
  gem.licenses      = ['MIT'],
  gem.executables   = []
  gem.files         = `git ls-files | grep -v myapp`.split("\n")
  gem.test_files    = `git ls-files -- test/*`.split("\n")
  gem.name          = "pinball_wizard"
  gem.require_paths = ["lib"]
  gem.version       = PinballWizard::VERSION
  gem.required_ruby_version = '>= 1.9'
end
