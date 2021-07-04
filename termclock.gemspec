# frozen_string_literal: true
require_relative "lib/termclock/version"

Gem::Specification.new do |s|
	s.name = "termclock"
	s.version = Termclock::VERSION
	s.authors = ["Sourav Goswami"]
	s.email = ["souravgoswami@protonmail.com"]
	s.summary = "A clock for Linux VTE"
	s.description = s.summary
	s.homepage = "https://github.com/souravgoswami/termclock"
	s.license = "MIT"
	s.required_ruby_version = Gem::Requirement.new(">= 2.5.0")
	s.files = Dir.glob(%w(exe/** lib/translations/*.json lib/**/*.rb))
	s.executables = s.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
	s.require_paths = ["lib"]
	s.bindir = "exe"
	s.add_runtime_dependency 'linux_stat', '>= 2.3.0'
end
