# Termclock
A clock that runs on the LinuxTerminal!

![Preview](https://github.com/Souravgoswami/termclock/blob/master/previews/preview.gif)

This project is a Ruby gem, a continuation of my previous project [term-clock](https://github.com/Souravgoswami/term-clock).

TermClock isn't just a clock, it also shows various information about the system as well.

## Dependencies
This program depends on Ruby, and Rubygem. It also has dependency of LinuxStat.
To install the whole gem, you need these packages:

1. A Linux Virtual Terminal Emulator (not TTYs)
2. Noto Fonts Emoji or Fonts Noto Color Emoji
3. GCC
4. Make

On ArchLinux, you can install all of them simply:

```
# pacman -S ruby gcc make noto-fonts-emoji
```

On Ubuntu, LinuxMint, Kali Linux, Debian and other Debian based distributions
however, you also need ruby-dev package once, as a build-time dependency of LinuxStat,
you can uninstall it (ruby-dev) once the program is built:

```
# apt install ruby ruby-dev gcc make fonts-noto-color-emoji
```

In both cases, gcc and make are buildtime dependency and you can remove them
once the program is built.

## Installation
To install this gem, run:

```
$ gem install termclock
```

## Usage
### To run termclock, open the terminal and type:

```
$ termclock
```

### Termclock also accepts arguments.
Here are list of all the arguments:
```
1. Information:
	--help|-h			Shows this help section
	--version|-v			Shows termclock version

2. Style:
	--bold|-b			Make texts bold
	--italic|-i			Make texts italic
	--character=|char=		Draws specified character
	--clean				Just run the clean bare clock
	--colour=|-c=			Specify hex colour (4 colours)
					[ with or without # ]

3. Information:
	--no-date|-nd			Shows no date
	--no-message|-nm		Shows no messages
	--no-sysinfo|-ni		Shows no system info
	--refresh|r			Specify delay or refresh time
	--text-colour|-tc		Specify text colour (2 colours)

4. Formats:
	--date-format=|-df=		Specify the date format
					[ Run date --help for formats ]
	--time-format=|-tf=		Specify the time format
					[ Run date --help for formats ]

Supported characters are 0 - 9, a - z, /, \, !, %, and |.

This is Termclock v0.2.0

```

Run termclock `--help` or termclock `-h` to see the help.

#### Here are some basic examples:
+ You can specify the colours:

```
$ termclock --colour=f55,55f,55f,eee
# Or
$ termclock -c=f55,55f,55f,eee
```

+ You can also change the default characters:

```
$ termclock -char="⬢"
# Or
$ termclock --character="⬢"
```

A basic example is:
You can pass multiple characters, which will be shown in the termclock.

```
$ termclock -char="☺ ☹ "
# Or
$ termclock -char="꧁ ꧂ "
```

The 2nd one looks like:

![Preview](https://github.com/Souravgoswami/termclock/blob/master/previews/preview2.jpg)

+ To change the default message (text) colour:

```
termclock -text-colour=fa0,55f
# Or
termclock -tc=fa0,55f
```

### Colours
The colours termclock accept are hex colours. You can have either of these formats:
1. #ff5555
2. #ff5
3. ff5555
4. ff5

Using either #3eb or 3eb is equivalent to #33eebb.
Using either #3ce3b5 is same as 3ce3b5 (no #).

Note that any characters upto 3 bytes work. An emoji can break term clock's look.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Souravgoswami/termclock.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
