NOCASESENSITIVITY = %i(
	bn
	hi
	ru
)

TRANSLATIONS = {
	bn: {
		'0' => ?০,
		'1' => ?১,
		'2' => ?২,
		'3' => ?৩,
		'4' => ?৪,
		'5' => ?৫,
		'6' => ?৬,
		'7' => ?৭,
		'8' => ?৮,
		'9' => ?৯,

		'monday' => 'সোমবার',
		'tuesday' => 'মঙ্গলবার',
		'wednesday' => 'বুধবার',
		'thursday' => 'বৃহস্পতিবার',
		'friday' => 'শুক্রবার',
		'saturday' => 'শনিবার',
		'sunday' => 'রবিবার',

		'mon' => 'সোমবার',
		'tue' => 'মঙ্গলবার',
		'wed' => 'বুধবার',
		'thu' => 'বৃহস্পতিবার',
		'fri' => 'শুক্রবার',
		'sat' => 'শনিবার',
		'sun' => 'রবিবার',

		'good morning' => 'সুপ্রভাত',
		'good afternoon' => 'শুভ অপরাহ্ন',
		'good evening' => 'শুভ সন্ধ্যা',
		'good night' => 'শুভ রাত্রি',

		'jan' => 'জানুয়ারী',
		'feb' => 'ফেব্রুয়ারী',
		'mar' => 'মার্চ',
		'apr' => 'এপ্রিল',
		'may' => 'মে',
		'jun' => 'জুন',
		'jul' => 'জুলাই',
		'aug' => 'আগস্ট',
		'sep' => 'সেপ্টেম্বর',
		'oct' => 'অক্টোবর',
		'nov' => 'নভেম্বর',
		'dec' => 'ডিসেম্বর',

		'january' => 'জানুয়ারী',
		'february' => 'ফেব্রুয়ারী',
		'march' => 'মার্চ',
		'april' => 'এপ্রিল',
		'may' => 'মে',
		'june' => 'জুন',
		'july' => 'জুলাই',
		'august' => 'আগস্ট',
		'september' => 'সেপ্টেম্বর',
		'october' => 'অক্টোবর',
		'november' => 'নভেম্বর',
		'december' => 'ডিসেম্বর',
	}
}

def translate(keyword, lang: :en, breakword: false)
	return keyword if lang == :en

	if NOCASESENSITIVITY.include?(lang)
		keyword = keyword.downcase
	end

	if breakword
		return keyword.chars.map { |x|
			tr = TRANSLATIONS.dig(lang, x)
			tr ? tr : x
		}.join
	end

	tr = TRANSLATIONS.dig(lang, keyword)
	tr ? tr : keyword
end
