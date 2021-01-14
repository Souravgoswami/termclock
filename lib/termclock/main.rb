module Termclock
	COLOURTERM = ENV.key?('COLORTERM')
	CLEAR = COLOURTERM ? "\e[H\e[2J\e[3J" : "\e[H"

	def self.start(colour1, colour2, colour3, colour4, textcolour1 = nil,
		textcolour2 = nil, sleep: 0.1, bold: false,
		print_info: true, print_message: true,
		print_date: true
	)

		newline = ?\n.freeze
		space = ?\s.freeze

		generate = proc do |start, stop, n = 5|
			r_op = r_val = nil
			ary = []

			if start > stop
				r_op, r_val = :-, start.-(stop).fdiv(n - 1)
			elsif start < stop
				r_op, r_val = :+, stop.-(start).fdiv(n - 1)
			end

			_r = r_op ? start.send(r_op, r_val * -1) : start
			n.times {
				_r = _r.send(r_op, r_val) if r_op
				ary << _r.clamp(0, 255).to_i
			}

			ary
		end

		gc_compact, gc_compacted = GC.respond_to?(:compact), Time.now.to_i + 7200
		print "\e[H\e[2J\e[3J" unless COLOURTERM

		r1, g1, b1 = *colour1
		r2, g2, b2 = *colour2
		r3, g3, b3 = *colour3
		r4, g4, b4 = *colour4

		# colour1 -> colour3
		rs1 = generate.(r1, r3)
		gs1 = generate.(g1, g3)
		bs1 = generate.(b1, b3)

		# colour2 -> colour4
		rs2 = generate.(r2, r4)
		gs2 = generate.(g2, g4)
		bs2 = generate.(b2, b4)

		# All Gradient Colours
		colours = [rs1, gs1, bs1].transpose.zip([rs2, gs2, bs2].transpose)
		colours.unshift(colours[0])
		colours.push(colours[-1])

		# Text colours
		tc1 = textcolour1 ? hex2rgb(textcolour1) : hex2rgb('5555ff')
		tc2 = textcolour2 ? hex2rgb(textcolour2) : hex2rgb('3ce3b5')

		cpu_usage = 0
		cpu_usage_t = Thread.new { }

		current_net_usage = ''
		current_net_usage_t = Thread.new { }

		message_time = Time.now.to_i - 5
		message = ''
		message_final = ''
		message_temp = ''
		caret = "\u2588"

		date, info = '', ''

		get_message = proc {
			case Time.now.hour
			when 5...12
				"\u{1F304} Good Morning..."
			when 12...16
				"\u26C5 Good Afternoon..."
			when 16...18
				"\u{1F307} Good Evening..."
			when 18...20
				"\u{1F31F} Good Evening..."
			when 20...24
				"\u{1F303} Good Night..."
			else
				"\u{2728} Good Night..."
			end
		}

		i = -1
		while true
			i += 1
			time_now = Time.now
			height, width = *STDOUT.winsize

			if time_now.to_f./(0.5).to_i.even?
				splitter = ?:.freeze
				_caret = caret
			else
				splitter = ?$.freeze
				_caret = ''
			end

			if print_message
				message_align = width - i % width + message.length / 2 - 4
				if (width - i % width <= message.length)
					message.replace(message[1..-1])
					message_align = width - i % width + 4
				else
					message.clear if width - i % width == width
					message_temp = get_message.call

					if message_temp != message
						message << message_temp[message.length..message.length  + 1]
					end
				end

				message_final = message.rjust(message_align).+(_caret).gradient(tc1, tc2, exclude_spaces: true, bold: bold)
			end

			if print_info
				info = system_info(width, tc1, tc2, bold)
			end

			if print_date
				date = time_now.strftime('%a, %d %m %Y').center(width)
					.gradient(tc1, tc2, bold: bold)
			end

			time = time_now.strftime('%H %M %S %2N').split.join(splitter)
			art = Termclock::ParseCharacters.display(time).lines

			art_aligned = art.each_with_index do |x, i|
				chomped = x.chomp(''.freeze).+(newline)
				gr = chomped.gradient(*colours[i], bold: bold)
				x.replace(space.*(width./(2.0).-(chomped.length / 2.0).abs.to_i + 1) + gr)
			end.join

			vertical_gap = "\e[#{height./(2.0).-(art.length / 2.0).to_i + 1}H"

			print "#{CLEAR}#{info}#{vertical_gap}#{art_aligned}\n#{date}\n\n#{message_final}"

			if gc_compact && time_now.to_i > gc_compacted
				GC.compact
				gc_compacted = time_now.to_i + 7200
			end

			sleep(sleep)
		end
	end
end
