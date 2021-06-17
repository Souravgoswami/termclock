require 'linux_stat'
require 'io/console'

require_relative "termclock/version"

module Termclock
	GC_COMPACT_TIME = 7200
	CLEAR = "\e[H\e[2J\e[3J".freeze
	ANTIFLICKER = "\e[J\e[1;1H".freeze
	NEWLINE = ?\n.freeze
	SPACE = ?\s.freeze
	TAB = ?\t.freeze
	EMPTY = ''.freeze
	EPSILON = 5.0e-07

	# All languages
	LANGS = %i(
		bn de en es fr hi it ru
	)

	# LANGUAGES
	lang = (ENV['LC_ALL'] || ENV['LANG'] || :en).downcase.split(?_)[0].to_sym
	lang = :en unless LANGS.include?(lang)

	LANG = lang
end

require_relative "termclock/string"
require_relative "termclock/parse_characters"
require_relative "termclock/system_info"
require_relative "termclock/start"
require_relative "termclock/hex2rgb"
require_relative 'termclock/translate.rb'
