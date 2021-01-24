require 'linux_stat'
require 'io/console'
require_relative "termclock/version"

module Termclock
	CLEAR = "\e[H\e[2J\e[3J".freeze
	NEWLINE = ?\n.freeze
	SPACE = ?\s.freeze
	TAB = ?\t.freeze
	EMPTY = ''.freeze
	EPSILON = 5.0e-07
end

require_relative "termclock/string"
require_relative "termclock/parse_characters"
require_relative "termclock/system_info"
require_relative "termclock/start"
require_relative "termclock/hex2rgb"
