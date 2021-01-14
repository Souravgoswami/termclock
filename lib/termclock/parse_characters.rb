module Termclock
	module ParseCharacters
		NEWLINE = ?\n.freeze
		CHARACTERS = <<~EOF.freeze
		# 0
		````````
		``    ``
		``    ``
		``    ``
		````````

		# 1
		   ``
		`````
		   ``
		   ``
		````````

		# 2
		````````
		      ``
		````````
		``
		````````

		# 3
		````````
		      ``
		````````
		      ``
		````````

		# 4
		``    ``
		``    ``
		````````
		      ``
		      ``

		# 5
		````````
		``
		````````
		      ``
		````````

		# 6
		````````
		``
		````````
		``    ``
		````````

		# 7
		````````
		      ``
		      ``
		      ``
		      ``

		# 8
		````````
		``    ``
		````````
		``    ``
		````````

		# 9
		````````
		``    ``
		````````
		      ``
		````````

		# :
		\u2B29\u2B29
		\u2B29\u2B29

		\u2B29\u2B29
		\u2B29\u2B29

		# $
		\s\s
		\s\s

		\s\s
		\s\s
		# A
		````````
		``    ``
		````````
		``    ``
		``    ``

		# B
		````````
		``     ``
		````````
		``     ``
		````````

		# C
		````````
		``
		``
		``
		````````

		# D
		````````
		``     ``
		``      ``
		``     ``
		````````

		# E
		````````
		``
		````````
		``
		````````

		# F
		````````
		``
		````````
		``
		``

		# G
		````````
		``
		``
		``  ````
		````````

		# H
		``    ``
		``    ``
		````````
		``    ``
		``    ``

		# I
		````````
		   `
		   `
		   `
		````````

		# J
		````````
		      ``
		      ``
		 ``   ``
		 ```````

		# K
		``    ``
		``  ``
		`````
		``  ``
		``    ``

		# L
		``
		``
		``
		``
		````````

		# M
		```  ```
		`` `` ``
		``    ``
		``    ``
		``    ``

		# N
		````  ``
		`` `` ``
		`` `` ``
		`` `` ``
		``  ````

		# O
		````````
		``    ``
		``    ``
		``    ``
		````````

		# P
		````````
		``    ``
		````````
		``
		``

		# Q
		````````
		``    ``
		````````
		      ``
		      ``

		# R
		````````
		``    ``
		````````
		`````
		``   ``

		# S
		````````
		``
		````````
		      ``
		````````

		# T
		````````
		   ``
		   ``
		   ``
		   ``

		# U
		``    ``
		``    ``
		``    ``
		``    ``
		````````

		# V
		``    ``
		``    ``
		``    ``
		 `` ``
		   `

		# W
		``    ``
		``    ``
		``    ``
		`` `  ``
		````````

		# X
		`      `
		  `  `
		    `
		  `   `
		`       `

		# Y
		``    ``
		``    ``
		````````
		   ``
		   ``

		# Z
		````````
		     ``
		   ``
		 ``
		````````
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
							chars = arg.chars.rotate(-1) if y == ?\n
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
