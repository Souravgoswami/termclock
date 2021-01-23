module Termclock
	def self.hex2rgb(hex)
		colour = hex.dup.to_s
		colour.strip!
		colour.downcase!
		colour[0] = EMPTY if colour[0] == ?#.freeze

		# out of range
		oor = colour.scan(/[^a-f0-9]/)

		unless oor.empty?
			invalids = colour.chars.map { |x|
				oor.include?(x) ? "\e[1;31m#{x}\e[0m" : x
			}.join

			puts "Hex Colour ##{invalids} is Out of Range"
			raise ArgumentError
		end

		clen = colour.length
		if clen == 3
			colour.chars.map { |x| x.<<(x).to_i(16) }
		elsif clen == 6
			colour.chars.each_slice(2).map { |x| x.join.to_i(16) }
		else
			sli = clen > 6 ? 'too long'.freeze : clen < 3 ? 'too short'.freeze : 'invalid'.freeze
			raise ArgumentError, "Invalid Hex Colour ##{colour} (length #{sli})"
		end
	end
end
