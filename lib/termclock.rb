# frozen_string_literal: true
COLOURTERM = ENV.key?('COLORTERM')
CLEAR = COLOURTERM ? "\e[H\e[2J\e[3J" : "\e[H"
$-n, $-s = ?\n, ?\s

require 'linux_stat'
require 'io/console'
require_relative "termclock/string"
require_relative "termclock/parse_characters"
require_relative "termclock/main"
require_relative "termclock/hex2rgb"
require_relative "termclock/version"
