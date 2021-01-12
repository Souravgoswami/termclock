# Termclock
A clock that runs on the LinuxTerminal!

![Preview](https://github.com/Souravgoswami/termclock/blob/master/previews/preview.gif)

This project is a Ruby gem, a continuation of my previous project [term-clock](https://github.com/Souravgoswami/term-clock).

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
