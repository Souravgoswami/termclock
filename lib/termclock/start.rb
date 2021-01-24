module Termclock
	def self.start(colour1, colour2, colour3, colour4,
		textcolour1 = nil, textcolour2 = nil,
		refresh: 0.1,
		bold: false,
		italic: false,
		print_info: true, print_message: true,
		print_date: true,
		time_format: "%H %M %S %2N",
		date_format: '%a, %d %B %Y',
		no_logo: false
		)

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
		print CLEAR

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
		message_counter = -1
		message = ''
		message_final = ''
		message_align = 0
		message_temp = ''
		point_five_tick = 0

		date, info = '', ''

		clock_emoji = ?\u{1F550}.ord.-(1).chr('utf-8')
		clock_emoji = 12.times.map { clock_emoji.next!.dup }

		braille = %W(\u2821 \u2811 \u2812 \u280A \u280C)

		get_message = proc {
			braille.rotate!
			braille_0 = braille[0]

			case Time.now.hour
			when 5...12
				"\u{1F304} #{braille_0} Good Morning #{braille_0} \u{1F304}"
			when 12...16
				"\u26C5 #{braille_0} Good Afternoon #{braille_0} \u26C5"
			when 16...18
				"\u{1F307} #{braille_0} Good Evening #{braille_0} \u{1F307}"
			when 18...20
				"\u{1F31F} #{braille_0} Good Evening #{braille_0} \u{1F31F}"
			when 20...24
				"\u{1F303} #{braille_0} Good Night #{braille_0} \u{1F303}"
			else
				"\u{2728} #{braille_0} Good Night #{braille_0} \u{2728}"
			end
		}

		version = "Termclock v#{Termclock::VERSION}"

		v_col1 = hex2rgb('ff0')
		v_col2 = hex2rgb('f55')
		v_col3 = hex2rgb('f55')
		v_col4 = hex2rgb('55f')

		vl_2 = version.length / 2
		_term_clock_v = version[0...vl_2].gradient(v_col1, v_col2, underline: true, bold: bold, italic: italic) <<
			version[vl_2..-1].gradient(v_col3, v_col4, underline: true, bold: bold, italic: italic)

		term_clock_v = ''

		chop_message = 0
		deviation = 0

		while true
			monotonic_time_1 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
			time_now = Time.now
			height, width = *STDOUT.winsize

			if time_now.to_f./(0.5).to_i.even?
				unless point_five_tick == 1
					point_five_tick = 1
					splitter = ?:.freeze
					clock_emoji.rotate!
				end
			else
				unless point_five_tick == 0
					point_five_tick = 0
					splitter = ?$.freeze
				end
			end

			unless no_logo
				term_clock_v = "\e[#{height}H #{clock_emoji[0]} #{_term_clock_v} \e[0m"
			end

			if print_message
				message_temp = get_message.call
				message_counter += 1
				message_length = message.length

				if (width - message_counter % width < 8)
					unless chop_message == message_temp.length
						chop_message += 1
						message_counter -= 1
						message_align -= 1
						message.replace(message_temp[chop_message..-1])
					end
				else
					chop_message = 0 unless chop_message == 0
					message.clear if width - message_counter % width == width
					message_align = width - message_counter % width + message_length - 4

					if message_temp != message
						if message_length < message_temp.length
							message.replace(message_temp[0..message_length])
						else
							message.replace(message_temp)
						end
					end
				end

				message_final = (message).rjust(message_align).gradient(
					tc1, tc2, exclude_spaces: true, bold: bold, italic: italic
				)
			end

			if print_info
				info = system_info(width).gradient(
					tc1, tc2, bold: bold, italic: italic
				)
			end

			if print_date
				date = time_now.strftime(date_format).center(width)
					.gradient(tc1, tc2, bold: bold, italic: italic, exclude_spaces: true)
			end

			time = time_now.strftime(time_format).split.join(splitter)
			art = Termclock::ParseCharacters.display(time).lines

			art_aligned = art.each_with_index do |x, i|
				chomped = x.chomp(EMPTY).+(NEWLINE)
				gr = chomped.gradient(*colours[i], bold: bold, italic: italic)

				w = width./(2.0).-(chomped.length / 2.0) + 2
				w = 0 if w < 0

				x.replace(SPACE.*(w) + gr)
			end.join

			vertical_gap = "\e[#{height./(2.0).-(art.length / 2.0).to_i + 1}H"

			print "#{CLEAR}#{info}#{vertical_gap}#{art_aligned}\n#{date}\n\n#{message_final}#{term_clock_v} -- #{deviation}"

			if gc_compact && time_now.to_i > gc_compacted
				GC.compact
				gc_compacted = time_now.to_i + 7200
			end

			monotonic_time_2 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
			time_diff = monotonic_time_2 - monotonic_time_1
			sleep_time = refresh.-(time_diff + EPSILON + deviation)
			sleep_time = 0 if sleep_time < 0

			deviation = Process.clock_gettime(Process::CLOCK_MONOTONIC) - monotonic_time_2
			sleep(sleep_time)
		end
	end
end
