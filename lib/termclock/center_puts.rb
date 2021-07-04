module Termclock
	def self.center_puts(message)
		winsize = STDOUT.winsize

		puts "\e[2J\e[H\e[3J\e[#{winsize[0] / 2}H"\
		"#{?\s.*(winsize[1] / 2 - message.bytesize / 2)}#{message}"
	end
end
