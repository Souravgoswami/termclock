require 'linux_stat'
require 'io/console'
require 'json'

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

	# Load translations
	TRANSLATION_FILES = {}

	Dir.glob(File.join(__dir__, 'translations', '*.json')).each { |x|
		next if x == '..'.freeze || x == ?..freeze || !File.readable?(x)

		TRANSLATION_FILES.merge!(
			File.basename(x).split(?..freeze).tap(&:pop).join(?..freeze) => x
		)
	}

	translation_file = TRANSLATION_FILES[LANG.to_s]

	TRANSLATIONS = if translation_file && File.readable?(translation_file)
		JSON.parse(IO.read(translation_file)).values[0] rescue {}
	else
		{}
	end
end

# Translation engine
require_relative 'termclock/translate.rb'

require_relative "termclock/string"
require_relative "termclock/parse_characters"
require_relative "termclock/system_info"
require_relative "termclock/start"
require_relative "termclock/hex2rgb"
