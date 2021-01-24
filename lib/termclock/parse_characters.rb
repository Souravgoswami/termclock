module Termclock
	module ParseCharacters
		CHARACTERS = <<~EOF.freeze
		#\s0
		````````
		``\s\s\s\s``
		``\s\s\s\s``
		``\s\s\s\s``
		````````

		#\s1
		\s\s\s``
		`````
		\s\s\s``
		\s\s\s``
		````````

		#\s2
		````````
		\s\s\s\s\s\s``
		````````
		``
		````````

		#\s3
		````````
		\s\s\s\s\s\s``
		````````
		\s\s\s\s\s\s``
		````````

		#\s4
		``\s\s\s\s``
		``\s\s\s\s``
		````````
		\s\s\s\s\s\s``
		\s\s\s\s\s\s``

		#\s5
		````````
		``
		````````
		\s\s\s\s\s\s``
		````````

		#\s6
		````````
		``
		````````
		``\s\s\s\s``
		````````

		#\s7
		````````
		\s\s\s\s\s\s``
		\s\s\s\s\s\s``
		\s\s\s\s\s\s``
		\s\s\s\s\s\s``

		#\s8
		````````
		``\s\s\s\s``
		````````
		``\s\s\s\s``
		````````

		#\s9
		````````
		``\s\s\s\s``
		````````
		\s\s\s\s\s\s``
		````````

		#\s:
		\u2B29\u2B29
		\u2B29\u2B29

		\u2B29\u2B29
		\u2B29\u2B29

		#\s$
		\s\s
		\s\s

		\s\s
		\s\s
		#\sA
		````````
		``\s\s\s\s``
		````````
		``\s\s\s\s``
		``\s\s\s\s``

		#\sB
		````````
		``\s\s\s\s\s``
		````````
		``\s\s\s\s\s``
		````````

		#\sC
		````````
		``
		``
		``
		````````

		#\sD
		````````
		``\s\s\s\s\s``
		``\s\s\s\s\s\s``
		``\s\s\s\s\s``
		````````

		#\sE
		````````
		``
		````````
		``
		````````

		#\sF
		````````
		``
		````````
		``
		``

		#\sG
		````````
		``
		``
		``\s\s````
		````````

		#\sH
		``\s\s\s\s``
		``\s\s\s\s``
		````````
		``\s\s\s\s``
		``\s\s\s\s``

		#\sI
		````````
		\s\s\s``
		\s\s\s``
		\s\s\s``
		````````

		#\sJ
		````````
		\s\s\s\s\s\s``
		\s\s\s\s\s\s``
		\s``\s\s\s``
		\s```````

		#\sK
		``\s\s\s\s``
		``\s\s``
		`````
		``\s\s``
		``\s\s\s\s``

		#\sL
		``
		``
		``
		``
		````````

		#\sM
		```\s\s```
		``\s``\s``
		``\s\s\s\s``
		``\s\s\s\s``
		``\s\s\s\s``

		#\sN
		````\s\s``
		``\s``\s``
		``\s``\s``
		``\s``\s``
		``\s\s````

		#\sO
		````````
		``\s\s\s\s``
		``\s\s\s\s``
		``\s\s\s\s``
		````````

		#\sP
		````````
		``\s\s\s\s``
		````````
		``
		``

		#\sQ
		````````
		``\s\s\s\s``
		````````
		\s\s\s\s\s\s``
		\s\s\s\s\s\s``

		#\sR
		````````
		``\s\s\s\s``
		````````
		`````
		``\s\s\s``

		#\sS
		````````
		``
		````````
		\s\s\s\s\s\s``
		````````

		#\sT
		````````
		\s\s\s``
		\s\s\s``
		\s\s\s``
		\s\s\s``

		#\sU
		``\s\s\s\s``
		``\s\s\s\s``
		``\s\s\s\s``
		``\s\s\s\s``
		````````

		#\sV
		``\s\s\s\s``
		``\s\s\s\s``
		``\s\s\s\s``
		\s``\s\s``\s
		\s\s\s``

		#\sW
		``\s\s\s\s``
		``\s\s\s\s``
		``\s\s\s\s``
		``\s`\s\s``
		````````

		#\sX
		``\s\s\s\s``
		\s``\s\s``
		\s\s\s``
		\s``\s\s``
		``\s\s\s\s``

		#\sY
		``\s\s\s\s``
		``\s\s\s\s``
		````````
		\s\s\s``
		\s\s\s``

		#\sZ
		````````
		\s\s\s\s\s``
		\s\s\s``
		\s``
		````````

		#\s/
		\s\s\s\s\s``\s
		\s\s\s\s``\s\s
		\s\s\s``\s\s\s
		\s\s``\s\s\s\s
		\s``\s\s\s\s\s

		#\s\\
		\s``\s\s\s\s\s
		\s\s``\s\s\s\s
		\s\s\s``\s\s\s
		\s\s\s\s``\s\s
		\s\s\s\s\s``\s

		#\s%
		\s\s\s\s\s``\s
		``\s\s``\s\s
		\s\s\s``\s\s\s
		\s\s``\s\s``
		\s``\s\s\s\s\s

		#\s|
		\s\s\s``\s\s\s
		\s\s\s``\s\s\s
		\s\s\s``\s\s\s
		\s\s\s``\s\s\s
		\s\s\s``\s\s\s

		#\s!
		\s\s\s``\s\s\s
		\s\s\s``\s\s\s
		\s\s\s``\s\s\s
		\s\s\s\s\s\s\s\s
		\s\s\s``\s\s\s
		EOF

		class << self
			@@characters ||= CHARACTERS.gsub(?`.freeze, ?\u2588).strip.split(/#+/).reduce({}) do |x, y|
				y.lstrip!
				lines = y[1..-1]
				next x unless y && lines
				max = lines.lines.max_by(&:length).length + 1

				hash = {
					y[0] => lines.lines.each { |z| z.replace(z.chomp.ljust(max) + NEWLINE) }.join
				}

				x.merge!(hash)
			end.freeze

			def transform_characters!(arg)
				@@transformed ||= nil
				fail RuntimeError, 'Characters already transformed!' if @@transformed
				@@transformed ||= true

				@@characters.values.each { |x|
					stripped = x.strip[0]
					chars = arg.chars.rotate(-1)

					if stripped
						replace_with = x.chars.map { |y|
							chars = arg.chars.rotate(-1) if y == NEWLINE
							next(y) if y != stripped
							chars.rotate!(1)[0]
						}.join

						x.replace(replace_with)
					end
				}
			end

			def display(c)
				j = []

				c.upcase.each_char { |x|
					@@characters.fetch(x, x).split(NEWLINE)
					.each_with_index { |z, i|
						_j = j[i]
						_j && _j << z || j[i] = z
					}
				}

				j.join(NEWLINE)
			end
		end
	end
end
