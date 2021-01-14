module Termclock
	@@cpu_usage = 0
	@@cpu_usage_t = Thread.new { }

	@@current_net_usage = ''
	@@current_net_usage_t = Thread.new { }

	class << self
		def system_info(width, tc1, tc2, bold)
			unless @@cpu_usage_t.alive?
				@@cpu_usage_t = Thread.new { @@cpu_usage = LS::CPU.usage(0.25) }
			end

			unless @@current_net_usage_t.alive?
				@@current_net_usage_t = Thread.new do
					_m = LS::Net.current_usage(0.25)

					_dl = LS::PrettifyBytes.convert_short_binary(_m[:received], precision: 0)
					_ul = LS::PrettifyBytes.convert_short_binary(_m[:transmitted], precision: 0)

					@@current_net_usage = "\u{1F4CA} Curr. DL/UL: #{sprintf "%-7s", _dl} | #{sprintf "%7s", _ul}"
				end
			end

			cpu = "\u{1F9E0} CPU: #{sprintf "%5s", @@cpu_usage}% (#{LS::CPU.count_online} / #{LS::CPU.count})"

			battery = if LS::Battery.present?
				stat = LS::Battery.stat
				emoji = LS::Battery.charging? ? "\u{1F4A1}" : "\u{1F50B}"
				plug = LS::Battery.charging? ? "\u{1F50C} " : ''.freeze
				"#{emoji} Battery: #{stat[:charge].to_i}% (#{plug}#{stat[:status]})"
			else
				''.freeze
			end

			user = "\u{1F481} User: #{LS::User.get_current_user.capitalize}"
			hostname = "\u{1F4BB} Hostname: #{LS::OS.hostname}"

			_m = LS::Net.total_bytes
			ip = "\u{1F30F} IP Addr: #{LS::Net.ipv4_private}"

			net_usage = "\u{1F4C8} Totl. DL/UL: #{sprintf "%-7s", LS::PrettifyBytes.convert_short_binary(_m[:received], precision: 0)}"\
			" | #{sprintf "%7s", LS::PrettifyBytes.convert_short_binary(_m[:transmitted], precision: 0)}"

			_m = LS::Memory.stat
			memory = "\u{1F3B0} Mem: #{LS::PrettifyBytes.convert_short_binary(_m[:used].to_i * 1024)}"\
			" / #{LS::PrettifyBytes.convert_short_binary(_m[:total].to_i * 1024)}"\
			" (#{_m[:percent_used].to_i}%)"

			_m = LS::Swap.stat
			swap = "\u{1F300} Swap: #{LS::PrettifyBytes.convert_short_binary(_m[:used].to_i * 1024)}"\
			" / #{LS::PrettifyBytes.convert_short_binary(_m[:total].to_i * 1024)}"\
			" (#{_m[:percent_used].to_i}%)"

			_m = LS::Filesystem.stat
			fs = "\u{1F4BD} FS: #{LS::PrettifyBytes.convert_short_binary(_m[:used].to_i)}"\
			" / #{LS::PrettifyBytes.convert_short_binary(_m[:total].to_i)}"\
			" (#{_m[:used].to_i*(100).fdiv(_m[:total].to_i).round(2)}%)"

			process = "\u{1F9EE} Process: #{LS::Process.count}"

			max_l = [hostname, process, ip, battery, @@current_net_usage, net_usage].map(&:length).max + 4

			<<~EOF.gradient(tc1, tc2, exclude_spaces: true, bold: bold)
				\s#{user}#{?\s.*(width.-(user.length + max_l).abs)}#{hostname}
				\s#{cpu}#{?\s.*(width.-(cpu.length + max_l).abs)}#{battery}
				\s#{memory}#{?\s.*(width.-(memory.length + max_l).abs)}#{ip}
				\s#{swap}#{?\s.*(width.-(swap.length + max_l).abs)}#{@@current_net_usage}
				\s#{fs}#{?\s.*(width.-(fs.length + max_l).abs)}#{net_usage}
			EOF
		end
	end
end
