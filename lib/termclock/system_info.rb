module Termclock
	@@cpu_usage = 0
	@@cpu_usage_t = Thread.new { }.join

	@@current_net_usage = "\u{1F4CA} Curr. DL/UL:"
	@@current_net_usage_t = Thread.new { }.join

	class << self
		def system_info(width)
			unless @@cpu_usage_t.alive?
				@@cpu_usage_t = Thread.new {
					_cpu_usage = LS::CPU.usage(0.25)
					_cpu_usage_i = _cpu_usage.to_i

					@@cpu_usage = "%0.2f" % _cpu_usage
				}
			end

			unless @@current_net_usage_t.alive?
				@@current_net_usage_t = Thread.new do
					_m = LS::Net.current_usage(0.25)

					_dl = LS::PrettifyBytes.convert_short_decimal(_m[:received], precision: 1)
					_ul = LS::PrettifyBytes.convert_short_decimal(_m[:transmitted], precision: 1)

					@@current_net_usage = "\u{1F4CA} Curr. DL/UL: #{sprintf "%-8s", _dl} | #{sprintf "%8s", _ul}"
				end
			end

			cpu = "\u{1F9E0} CPU: #{sprintf "%5s", @@cpu_usage}% (#{LS::CPU.count_online} / #{LS::CPU.count})"

			battery = if LS::Battery.present?
				stat = LS::Battery.stat
				emoji, plug = "\u{1F50B}".freeze, EMPTY

				if LS::Battery.charging?
					emoji, plug = "\u{1F4A1}".freeze, "\u{1F50C} ".freeze
				end

				"#{emoji} Battery: #{stat[:charge].to_i}% (#{plug}#{stat[:status]})"
			else
				EMPTY
			end

			user = "\u{1F481} User: #{LS::User.get_current_user.capitalize}"
			hostname = "\u{1F4BB} Hostname: #{LS::OS.hostname}"

			_m = LS::Net.total_bytes
			ip = "\u{1F30F} IP Addr: #{LS::Net.ipv4_private}"

			net_usage = "\u{1F4C8} Totl. DL/UL: #{sprintf "%-8s", LS::PrettifyBytes.convert_short_decimal(_m[:received], precision: 1)}"\
			" | #{sprintf "%8s", LS::PrettifyBytes.convert_short_decimal(_m[:transmitted], precision: 1)}"

			_m = LS::Memory.stat
			_m.default = 0

			memory = "\u{1F3B0} Mem: #{LS::PrettifyBytes.convert_short_decimal(_m[:used] * 1000)}"\
			" / #{LS::PrettifyBytes.convert_short_decimal(_m[:total] * 1000)}"\
			" (#{_m[:percent_used]}%)"

			_m = LS::Swap.stat
			_m.default = 0

			swap = "\u{1F300} Swap: #{LS::PrettifyBytes.convert_short_decimal(_m[:used] * 1000)}"\
			" / #{LS::PrettifyBytes.convert_short_decimal(_m[:total] * 1000)}"\
			" (#{_m[:percent_used]}%)"

			_m = LS::Filesystem.stat('/')
			_m.default = 0

			fs = "\u{1F4BD} FS: #{LS::PrettifyBytes.convert_short_decimal(_m[:used])}"\
			" / #{LS::PrettifyBytes.convert_short_decimal(_m[:total])}"\
			" (#{_m[:used].*(100).fdiv(_m[:total]).round(2)}%)"

			pt = LS::Process.types.values

			process = "\u{1F9EE} Process: T:#{sprintf "%4s", LS::Process.count}|"\
			"R:#{sprintf "%3s", pt.count(:running)}|"\
			"S:#{sprintf "%3s", pt.count(:sleeping)}|"\
			"I:#{sprintf "%3s", pt.count(:idle)}"

			_os_v = LS::OS.version
			os_v = unless _os_v.empty?
				" (#{_os_v})"
			else
				EMPTY
			end

			os = "\u{1F427} Distrib: #{LS::OS.distribution} #{LS::OS.machine}#{os_v}"

			_uptime = LS::OS.uptime
			_second = _uptime[:second]
			_second_i = _second.to_i

			hour = "%02d" % _uptime[:hour]
			minute = "%02d" % _uptime[:minute]
			second = "%02d" % _second_i
			ms = "%02d" % _second.-(_second_i).*(100)

			uptime = "\u{1F3A1} Uptime: #{hour}:#{minute}:#{second}:#{ms} (#{LS::OS.uptime_i}s)"

			_loadavg = LS::Sysinfo.loads.map! { |x| sprintf("%.2f", x) }
			loadavg = "\u{1F9FA} LoadAvg: 1m #{_loadavg[0]}|5m #{_loadavg[1]}|15m #{_loadavg[2]}"

			all_info = [
				user, hostname,
				os, battery,
				cpu, ip,
				memory, @@current_net_usage,
				swap, net_usage,
				fs, process,
				uptime, loadavg
			].map(&:to_s).reject(&:empty?)
			max_l = 0

			all_info.each_with_index { |x, i|
				max_l = x.length if i.odd? && x.length > max_l
			}

			max_l += 4

			all_info.each_slice(2).map { |x, y|
				"\s#{x}#{SPACE.*(width.-(x.length + max_l).abs)}#{y}"
			}.join(NEWLINE)
		end
	end
end
