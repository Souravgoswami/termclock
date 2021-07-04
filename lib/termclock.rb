require 'linux_stat'
require 'io/console'
require 'json'

require_relative "termclock/version"
require_relative "termclock/center_puts"

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
		bn en es fr hi it ru
	)

	# LANGUAGES
	env_lc_all = ENV['LC_ALL'] && !ENV['LC_ALL'].empty? && ENV['LC_ALL'].downcase.split(?_)[0].to_sym

	_lang = nil
	_lang = env_lc_all if LANGS.include?(env_lc_all)

	unless _lang
		env_language = ENV['LANGUAGE'] && !ENV['LANGUAGE'].empty? && ENV['LANGUAGE'].downcase.split(?_)[0].to_sym
		_lang = env_language if LANGS.include?(env_language)
	end

	unless _lang
		env_lang = ENV['LANG'] && !ENV['LANG'].empty? && ENV['LANG'].downcase.split(?_)[0].to_sym
		_lang = env_lang if LANGS.include?(env_lang)
	end

	unless _lang
		_lang = :en
	end

	LANG = _lang.freeze

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
		begin
			JSON.parse(IO.read(translation_file))
		rescue StandardError
			center_puts "Can't Parse Translation File!"
			sleep 0.5
			{}
		end
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
