class String
	NEWLINE = ?\n.freeze
	SPACE = ?\s.freeze
	TAB = ?\t.freeze
	EMPTY = ''.freeze

	def gradient(*all_rgbs,
		bg: false,
		exclude_spaces: false,
		bold: false, italic: false, underline: false
		)

		temp = ''

		r, g, b = all_rgbs[0]
		r2, g2, b2 = all_rgbs[1]
		rotate = all_rgbs.length > 2

		init = bg ? 48 : 38

		style = nil
		if bold || italic || underline
			style = "\e["
			style << '1;'.freeze if bold
			style << '3;'.freeze if italic
			style << '4;'.freeze if underline
			style.chop!
			style << 'm'.freeze
		end

		each_line do |c|
			temp << style if style

			_r, _g, _b = r, g, b
			chomped = !!c.chomp!(EMPTY)

			len = c.length
			n_variable = exclude_spaces ? c.delete("\t\s".freeze).length : len
			n_variable -= 1
			n_variable = 1 if n_variable < 1

			# colour operator, colour value
			r_op = r_val  = nil
			g_op = g_val = nil
			b_op = b_val = nil

			if r2 > r
				r_op, r_val = :+, r2.-(r).fdiv(n_variable)
			elsif r2 < r
				r_op, r_val = :-, r.-(r2).fdiv(n_variable)
			end

			if g2 > g
				g_op, g_val = :+, g2.-(g).fdiv(n_variable)
			elsif g2 < g
				g_op, g_val = :-, g.-(g2).fdiv(n_variable)
			end

			if b2 > b
				b_op, b_val = :+, b2.-(b).fdiv(n_variable)
			elsif b2 < b
				b_op, b_val = :-, b.-(b2).fdiv(n_variable)
			end

			# To avoid the value getting adding | subtracted from the initial character
			_r = _r.send(r_op, r_val * -1) if r_op
			_g = _g.send(g_op, g_val * -1) if g_op
			_b = _b.send(b_op, b_val * -1) if b_op

			i = -1
			while (i += 1) < len
				_c = c[i]

				if !exclude_spaces || (exclude_spaces && !(_c == SPACE || _c == TAB))
					_r = _r.send(r_op, r_val) if r_op
					_g = _g.send(g_op, g_val) if g_op
					_b = _b.send(b_op, b_val) if b_op
				end

				r_to_i = _r.to_i
				g_to_i = _g.to_i
				b_to_i = _b.to_i

				f_r = r_to_i < 0 ? 0 : r_to_i > 255 ? 255 : r_to_i
				f_g = g_to_i < 0 ? 0 : g_to_i > 255 ? 255 : g_to_i
				f_b = b_to_i < 0 ? 0 : b_to_i > 255 ? 255 : b_to_i

				ret = "\e[#{init};2;#{f_r};#{f_g};#{f_b}m#{_c}"
				temp << ret
			end

			ret = if !c.empty?
				chomped ? "\e[0m\n".freeze : "\e[0m".freeze
			elsif chomped
				NEWLINE
			end

			temp << ret

			if rotate
				all_rgbs.rotate!
				r, g, b = all_rgbs[0]
				r2, g2, b2 = all_rgbs[1]
			end
		end

		temp
	end

	def camelize!
		replace(split(SPACE).map(&:capitalize).join(SPACE))
	end
end
