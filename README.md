# Termclock
A clock that runs on the LinuxTerminal!

![Preview](https://github.com/Souravgoswami/termclock/blob/master/previews/preview.gif)

This project is a Ruby gem, a continuation of my previous project [term-clock](https://github.com/Souravgoswami/term-clock).

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
To run termclock, open the terminal and type:

```
$ termclock
```

Termclock also accepts arguments. You can specify the colours:

```
$ termclock --colour=f55,55f,55f,eee
```

Or

```
$ termclock -c=f55,55f,55f,eee
```

You can also change the default characters:

```
termclock -char="⬢"
```

Or
```
termclock --character="⬢"
```

Note that any characters upto 3 bytes work. An emoji can break term clock's look.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Souravgoswami/termclock.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
