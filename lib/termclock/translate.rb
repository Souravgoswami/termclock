module Termclock
	def self.translate(keyword, breakword: false)
		return keyword if LANG == :en

		characters = keyword.chars

		upcased = characters.all? { |x| x.ord.between?(65, 90) }
		downcased = upcased ? false : characters.all? { |x| x.ord.between?(97, 122) }
		capitalized = if (upcased || downcased)
			false
		else
			characters[0].ord.between?(65, 90) &&
				characters.drop(1).all? { |x| x.ord.between?(97, 122) }
		end

		if breakword
			return characters.map { |x|
				tr = TRANSLATIONS[x]

				if !tr
					tr = TRANSLATIONS[x.downcase]
				end

				tr.upcase! if tr && upcased
				tr.downcase! if tr && downcased
				tr.capitalize! if tr && capitalized

				tr ? tr : x
			}.join
		end

		tr = TRANSLATIONS[keyword]

		if !tr
			tr = TRANSLATIONS[keyword.downcase]

			tr.upcase! if tr && upcased
			tr.downcase! if tr && downcased
			tr.capitalize! if tr && capitalized
		end

		tr ? tr : keyword
	end
end
