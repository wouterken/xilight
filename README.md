# Xilight

Xilight provides a Ruby library and a CLI interface to control your Xiaomi Yeelight programmatically.

**Note**: It requires your yeelight to be configured to [development mode](https://www.yeelight.com/en_US/developer).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'xilight'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xilight

## Usage

### Library

Read the API docs [here](https://rubydoc.info/github/wouterken/xilight/master/Xilight/Yeelight).

###  CLI

#### Help

    yee -h

#### Discovery
    Command:
      yee discover

    Usage:
      yee discover

    Description:
      Discover Yeelights and save to ~/.config/.yeelights

    Options:
      --help, -h                        # Print this help

    Examples:
      yee discover

#### List Lights

    Command:
      yee list

    Usage:
      yee list

    Description:
      List known Yeelights

    Options:
      --help, -h                        # Print this help

    Examples:
      yee list

#### Set Light Name

    Command:
      yee name

    Usage:
      yee name NAME

    Description:
      Set name for Yeelight

    Arguments:
      NAME                  # REQUIRED Name to set for light

    Options:
      --light=VALUE, -l VALUE           # ID/index of Yeelight to target, default: "0"
      --help, -h                        # Print this help

    Examples:
      yee name name -l 1 foo # Set the name for light#1 to "foo"


#### Set RGB

    Command:
      yee rgb

    Usage:
      yee rgb R G B

    Description:
      Set RGB for Yeelight

    Arguments:
      R                     # REQUIRED Red (0-255)
      G                     # REQUIRED Green (0-255)
      B                     # REQUIRED Blue (0-255)

    Options:
      --light=VALUE, -l VALUE           # ID/index of Yeelight to target, default: "0"
      --name=VALUE, -n VALUE            # Name of Yeelight to target
      --help, -h                        # Print this help

    Examples:
      yee rgb 255 0 0 # set light to red (red 255, green 0, blue 0)
      yee rgb 0 0 180 -n foo# set light with name foo to blue (red 0, green 0, blue 180)
      yee rgb 255 255 255 -l 3# set light #3 to white (red 255, green 255, blue 255)


#### Brightness

    Command:
      yee bright

    Usage:
      yee bright BRIGHTNESS

    Description:
      Set Brightness for Yeelight

    Arguments:
      BRIGHTNESS            # REQUIRED Brightness (0-100)

    Options:
      --light=VALUE, -l VALUE           # ID/index of Yeelight to target, default: "0"
      --name=VALUE, -n VALUE            # Name of Yeelight to target
      --help, -h                        # Print this help

    Examples:
      yee bright 100 # full brightness
      yee bright 50 -n foo  # 50% brightness for light with name foo
      yee bright 25 -l 3  # 25% brightness for light#3

#### Set HSV

    Command:
      yee hsv

    Usage:
      yee hsv H S

    Description:
      Set HSV for Yeelight

    Arguments:
      H                     # REQUIRED Hue (0-359)
      S                     # REQUIRED Saturation (0-100)

    Options:
      --light=VALUE, -l VALUE           # ID/index of Yeelight to target, default: "0"
      --name=VALUE, -n VALUE            # Name of Yeelight to target
      --help, -h                        # Print this help

    Examples:
      yee hsv 180 40 # set hue to 180 and saturation to 40
      yee hsv 200 20 -n foo# set light with name foo to hue: 200, saturation: 20
      yee hsv 359 90 -l 3# set light #3  to hue: 359, saturation: 90

#### Turn Off

    Command:
      yee off

    Usage:
      yee off


    Description:
      Turn Off Yeelight

    Options:
      --light=VALUE, -l VALUE           # ID/index of Yeelight to target, default: "0"
      --name=VALUE, -n VALUE            # Name of Yeelight to target
      --help, -h                        # Print this help

    Examples:
      yee off # turn default/first light off
      yee off -n kitchen # turn light with name 'kitchen' off
      yee off -l 3 # turn light #3 off

#### Turn On
    Command:
      yee on

    Usage:
      yee on

    Description:
      Turn on Yeelight

    Options:
      --light=VALUE, -l VALUE           # ID/index of Yeelight to target, default: "0"
      --name=VALUE, -n VALUE            # Name of Yeelight to target
      --help, -h                        # Print this help

    Examples:
      yee on # turn default/first light on
      yee on -n kitchen # turn light with name 'kitchen' on
      yee on -l 3 # turn light #3 on

#### Toggle

    Command:
      yee toggle

    Usage:
      yee toggle

    Description:
      Toggle Yeelight

    Options:
      --light=VALUE, -l VALUE           # ID/index of Yeelight to target, default: "0"
      --name=VALUE, -n VALUE            # Name of Yeelight to target
      --help, -h                        # Print this help

    Examples:
      yee toggle # toggle default/first light
      yee toggle -n kitchen # toggle light with name 'kitchen'
      yee toggle -l 3 # toggle light #3

#### Version

    Command:
      yee version

    Usage:
      yee version

    Description:
      Print version

    Options:
      --help, -h                        # Print this help

    Examples:
      yee version

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wouterken/xilight. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

