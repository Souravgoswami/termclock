module Termclock
	module ParseCharacters
		NEWLINE = ?\n.freeze
		CHARACTERS = <<~EOF.freeze
		# 0
		```````
		``   ``
		``   ``
		``   ``
		```````

		# 1
		   ``
		 ````
		   ``
		   ``
		```````

		# 2
		```````
		     ``
		```````
		``
		```````

		# 3
		```````
		     ``
		```````
		     ``
		```````

		# 4
		``   ``
		``   ``
		```````
		     ``
		     ``

		# 5
		```````
		``
		```````
		     ``
		```````

		# 6
		```````
		``
		```````
		``   ``
		```````

		# 7
		```````
		     ``
		     ``
		     ``
		     ``

		# 8
		```````
		``   ``
		```````
		``   ``
		```````

		# 9
		```````
		``   ``
		```````
		     ``
		```````

		# :
		⬩⬩
		⬩⬩

		⬩⬩
		⬩⬩

		# $
		\s\s
		\s\s

		\s\s
		\s\s
		# A
		```````
		``   ``
		```````
		``   ``
		``   ``

		# B
		``````
		``   ``
		``````
		``   ``
		``````

		# C
		```````
		``
		``
		``
		```````

		# D
		`````
		``   ``
		``    ``
		``   ``
		`````

		# E
		```````
		``
		```````
		``
		```````

		# F
		```````
		``
		```````
		``
		``

		# G
		```````
		``
		``
		``   ```
		````````

		# H
		``   ``
		``   ``
		```````
		``   ``
		``   ``

		# I
		```````
		   `
		   `
		   `
		```````

		# J
		```````
		     ``
		     ``
		 ``  ``
		 ``````

		# K
		``   ``
		`` ``
		````
		`` ``
		``   ``

		# L
		``
		``
		``
		``
		``````

		# M
		```  ```
		`` `` ``
		``    ``
		``    ``
		``    ``

		# N
		````    ``
		``  `   ``
		``   `  ``
		``    ` ``
		``     ```

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
		```````
		``   ``
		```````
		     ``
		     ``

		# R
		```````
		``   ``
		```````
		````
		``  ``

		# S
		```````
		``
		```````
		     ``
		```````

		# T
		````````
		   ``
		   ``
		   ``
		   ``

		# U
		``   ``
		``   ``
		``   ``
		``   ``
		```````

		# V
		``   ``
		``   ``
		``   ``
		 `` ``
		   `

		# W
		``     ``
		``     ``
		``     ``
		``  `  ``
		`````````

		# X
		``      ``
		  ``  ``
		    ``
		  ``  ``
		``      ``

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
				@@characters.values.each { |x|
					stripped = x.strip[0]
					x.gsub!(stripped, arg) if stripped
				}
			end

			def display(c)
				j = ['', '']

				c.upcase.chars.map! { |x|
					@@characters.fetch(x, x).split(?\n.freeze)
					.each_with_index { |z, i|
						_j = j[i]
						_j && _j << z || j[i] = z
					}
				}

				j.join(?\n.freeze)
			end
		end
	end
end
