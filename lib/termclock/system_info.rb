module Termclock
	FILESYSTEM, FILESYSTEM_LABEL = if LS::FS.stat('/')[:blocks].to_i == 0
		_pwd =  Dir.pwd
		pwd = _pwd.length > 8 ? _pwd[0..5] + '...' : _pwd
		[?..freeze, pwd]
	else
		[?/.freeze, ?/.freeze]
	end.freeze

	@@cpu_usage = 0
	@@cpu_usage_t = Thread.new { }.join

	@@current_net_usage = "\u{1F4CA} Curr. DL/UL:"
	@@current_net_usage_t = Thread.new { }.join

	class << self
		def system_info(width, tc1, tc2, bold, italic)
			unless @@cpu_usage_t.alive?
				@@cpu_usage_t = Thread.new {
					_cpu_usage = LS::CPU.usage(0.25)
					@@cpu_usage = _cpu_usage ? "%0.2f".freeze % _cpu_usage : nil
				}
			end

			unless @@current_net_usage_t.alive?
				@@current_net_usage_t = Thread.new do
					_m = LS::Net.current_usage(0.25)

					_dl = _m[:received]
					_ul = _m[:transmitted]

					@@current_net_usage = if _dl && _ul
						dl = LS::PrettifyBytes.convert_short_decimal(_dl)
						ul = LS::PrettifyBytes.convert_short_decimal(_ul)

						"\u{1F4CA} Curr. DL/UL: #{"%-9s" % dl} | #{ "%9s" % ul}"
					else
						EMPTY
					end
				end
			end

			cpu = if @@cpu_usage
				 "\u{1F9E0} CPU: #{"%6s" % @@cpu_usage}% (#{LS::CPU.count_online}/#{LS::CPU.count})"
			else
				EMPTY
			end

			battery = if LS::Battery.present?
				stat = LS::Battery.stat
				charge = stat[:charge].to_i

				emoji, plug = "\u{1F50B}".freeze, EMPTY

				if LS::Battery.charging?
					emoji, plug = "\u{1F4A1}".freeze, "\u{1F50C} ".freeze
				end

				lives = "\u2665 ".freeze.*(charge.fdiv(20).ceil).chop

				"#{emoji} Battery: #{charge}% #{lives} (#{plug}#{stat[:status]})"
			else
				EMPTY
			end

			user = "\u{1F481} User: #{LS::User.get_current_user.capitalize}"
			hostname = "\u{1F4BB} Hostname: #{LS::OS.hostname}"

			_m = LS::Net.total_bytes
			ip = "\u{1F30F} IP Addr: #{LS::Net.ipv4_private}"

			_received = _m[:received]
			_transmitted = _m[:transmitted]

			tot_received = _received ? "\u{1F4C8} Totl. DL/UL: #{'%-9s'.freeze % LS::PrettifyBytes.convert_short_decimal(_m[:received])}" : nil
			tot_transmitted = _transmitted ? " | #{'%9s'.freeze % LS::PrettifyBytes.convert_short_decimal(_transmitted)}" : nil

			net_usage = if tot_received && tot_transmitted
				tot_received + tot_transmitted
			else
				EMPTY
			end

			_m = LS::Memory.stat
			_m.default = 0

			memory = "\u{1F3B0} Mem: #{LS::PrettifyBytes.convert_short_decimal(_m[:used] * 1000)}"\
			" / #{LS::PrettifyBytes.convert_short_decimal(_m[:total] * 1000)}"\
			" (#{"%.2f" % _m[:percent_used]}%)"

			_m = LS::Swap.stat
			_m.default = 0

			swap = "\u{1F300} Swap: #{LS::PrettifyBytes.convert_short_decimal(_m[:used] * 1000)}"\
			" / #{LS::PrettifyBytes.convert_short_decimal(_m[:total] * 1000)}"\
			" (#{"%.2f" % _m[:percent_used]}%)"

			_m = LS::Filesystem.stat(FILESYSTEM)
			_m.default = 0

			fs = "\u{1F4BD} FS (#{FILESYSTEM_LABEL}): #{LS::PrettifyBytes.convert_short_decimal(_m[:used])}"\
			" / #{LS::PrettifyBytes.convert_short_decimal(_m[:total])}"\
			" (#{"%.2f" % _m[:used].*(100).fdiv(_m[:total]).round(2)}%)"

			pt = LS::Process.types.values

			process = if pt.length > 0
				"\u{1F3ED} Process: T:#{"%4s" % pt.length}|"\
				"R:#{"%3s" % pt.count(:running)}|"\
				"S:#{"%3s" % pt.count(:sleeping)}|"\
				"I:#{"%3s" % pt.count(:idle)}"
			else
				EMPTY
			end

			@@os_v ||= unless LS::OS.version.empty?
				" (#{LS::OS.version})"
			else
				EMPTY
			end

			@@os ||= "\u{1F427} Distrib: #{LS::OS.distribution} #{LS::OS.machine}#{@@os_v}"

			_temp_uptime = LS::OS.uptime

			_uptime = unless _temp_uptime.empty?
				_temp_uptime
			else
				_u = LS::OS.uptime_i
				{
					hour: _u / 3600,
					minute: _u % 3600 / 60,
					second: _u % 3600 % 60,
					jiffy: 0
				}
			end

			_second = _uptime[:second]
			_second_i = _second.to_i

			hour = "%02d" % _uptime[:hour]
			minute = "%02d" % _uptime[:minute]
			second = "%02d" % _uptime[:second]
			jiffy = "%02d" % _uptime[:jiffy]

			uptime = "\u{1F3A1} Uptime: #{hour}:#{minute}:#{second}:#{jiffy} (#{LS::OS.uptime_i}s)"

			_loadavg = LS::Sysinfo.loads.map! { |x| "%.2f" % x }
			loadavg = "\u{1F525} LoadAvg: 1m #{_loadavg[0]}|5m #{_loadavg[1]}|15m #{_loadavg[2]}"

			all_info = []
			max_l = 0
			i = -1

			[
				user, hostname,
				@@os, battery,
				cpu, ip,
				memory, @@current_net_usage,
				swap, net_usage,
				fs, process,
				uptime, loadavg
			].each { |x|
				unless x.empty?
					all_info << x
					i += 1

					if i.odd?
						_x_len = x.length
						max_l = _x_len if max_l < _x_len
					end
				end
			}

			max_l += 4

			all_info.each_slice(2).map { |x, y|
				_diff = width.-(x.length + max_l)
				_diff = 0 if _diff < 1
				y_to_s = y.to_s

				padding = "#{SPACE * _diff}"
				str = SPACE + x + padding + y_to_s

				grads = SPACE + x.gradient(tc1, tc2, bold: bold, italic: italic) +
					padding +
					y_to_s.gradient(tc1, tc2, bold: bold, italic: italic)

				len = str.chars.map { |x|
					_x = x.bytesize./(2)
					_x == 0 ? 1 : _x
				}.sum

				w = width - 2

				len < w ? grads.+(SPACE.*(w - len)) : grads
			}.join(NEWLINE)
		end
	end
end
