# evkill [![GitHub Workflow Status](https://img.shields.io/github/workflow/status/enteee/evkill/Cross%20Compile)][Build] [![GitHub language evkill](https://img.shields.io/github/languages/count/Enteee/evkill)][evkill] [![GitHub top language](https://img.shields.io/github/languages/top/Enteee/evkill)][evkill] [![GitHub contributors](https://img.shields.io/github/contributors/Enteee/evkill)][evkill]
_A silencer for evdev_

Quick and dirty disable your `/dev/input/` event sources for the rest of your
system. `evkill` grabs evdev event sources in exclusive mode. This has the
effect that no event will be forwarded as long as `evkill` runs. For portability
the executable is statically linked with [musl][musl] and cross compiled for various different
architectures.

## Why?

If you ever tried to disable a piece of hardware, you probably found yourself
considering the following options:

1. Unplug the device
2. Unload the driver for the device (`modprobe -r`)
3. Configure the driver to ignore the device
4. Configure your X server to not forward device events
5. Use `evkill`

Option 1. is very hard if your device is a hardware button soldered onto the
board. In case you attempt 2. for general purpose device or event drivers such
as usbhid or evdev, you will end up with a deaf system. For most drivers 3. is
only really possible at compile time or at run-time through option number 4. But
who wants to mess around with X server configuration if you only need to disable
a device quick an dirty? In that case use `evkill`.

## How?

`evkill` send the ioctl EVIOCGRAB to the input device. Evdev will then grant
exclusive access to the input device for the `evkill` process. Which will on
the other hand disable event forwarding to every other process as long as
`evkill` runs. Killing the `evdev` process will enable enable the input device
again.

## Installation

```sh
$ curl https://raw.githubusercontent.com/Enteee/evkill/master/install.sh | sh
```

## Usage

```
usage: evkill <device>
```

## Example

```sh
$ sudo evkill /dev/input/event/0
```

## Build

1. [Install nix](https://nixos.org/download.html): `curl -L https://nixos.org/nix/install | sh`
2. `nix-build`

**Note**: Find the built binary under: `result/bin/evkill`

## Cross Compile

Using the power of nix, `evkill` supports cross compilation.

* reMarkable: `nix-build --arg crossTarget '"armv7l-unknown-linux-musleabi"'`
* Raspberry Pi: `nix-build --arg crossTarget '"armv6l-unknown-linux-musleabi"'`

## Contributing

We encourage you to contribute to this project :wrench: :rocket: ! Please check
out the [Contributing guide](/CONTRIBUTING.md) for guidelines about how to
proceed. Join us!

## Development Environment

Enter a fully fledged and ready for compilation development by running
`nix-shell`. From there, you can build `evkill` with `cargo build`.


[evkill]:https://github.com/Enteee/evkill
[Build]:https://github.com/Enteee/evkill/actions
[musl]:https://www.musl-libc.org/
