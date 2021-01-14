require 'linux_stat'
require 'io/console'

module Termclock
	COLOURTERM = ENV.key?('COLORTERM')
	CLEAR = COLOURTERM ? "\e[H\e[2J\e[3J" : "\e[H"
	NEWLINE = ?\n.freeze
	SPACE = ?\s.freeze
	TAB = ?\t.freeze
end

require_relative "termclock/string"
require_relative "termclock/parse_characters"
require_relative "termclock/system_info"
require_relative "termclock/main"
require_relative "termclock/hex2rgb"
require_relative "termclock/version"
