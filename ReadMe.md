
# A Zig static library for the pico-sdk

## Overview

This repository demonstrates how to compile Zig into a static library, that can be linked by a pico-sdk project.

The Zig code is minimal:

```zig
// src/root.zig
const zig = "Zig";
pub export fn helloFrom() usize {
    return @intFromPtr(zig);
}
```

The [pico](pico/) directory contains a bare-bones pico-sdk project, similar to [the hello usb example](https://github.com/raspberrypi/pico-examples/blob/master/hello_world/usb/hello_usb.c). The CMakeLists.txt is set up to call `zig build-lib` on [root.zig](src/root.zig), and link the result. [main.c](pico/src/main.c) calls helloFrom() and prints the result to the USB serial port.

Lastly, [my_module.h](pico/include/my_module.h) contains the C declaration for `helloFrom()`. At this time (Zig 0.14.0) `zig build-lib` seems not able to emit a header file describing the public interface.

## Compile and link example binary

### Compile

```bash
mkdir pico/build
(cd pico/build && cmake .. && make)
```

Those commands will:

- Create a pico/build folder
- Compile the pico-sdk project inside the pico/ folder and store results in the pico/build folder
- Compile the zig static library (src/root.zig)
- Link the two
- Emit rp pico compatible binaries in [pico/build/](pico/build/)

### Flash

To flash the binary on a rp pico board:

- Hold the boot button while powering up the pico
- Check that the rp pico is mounted as a usb drive
- Copy the `pico/build/hello_world.uf2` to the pico usb drive

Now the pico will print the message "Hello from Zig!" on the USB serial port.

Use a serial port tool such as Arduino's serial monitor or VSCode Teleport plugin to see the messages.

## Compile static library using zig build-lib

```bash
$ zig build-lib src/root.zig \
  --name my_module \
  -static \
  -target thumb-freestanding-eabi \
  -mcpu cortex_m0plus

$ ls
libmy_module.a libmy_module.a.o
```

The .o file looks to be a valid ELF object file:

```bash
$ file libmy_module.a.o
libmy_module.a.o: ELF 32-bit LSB relocatable, ARM, EABI5 version 1 (SYSV), with debug_info, not stripped
```

The archive looks weird:

```bash
$ ar -t libmy_module.a
/
//
/0
```

The archive seems to contain the library though:

```bash
$ ar -p libmy_module.a | strings
helloFrom
...
zig 0.14.0
...
cortex-m0plus
```

And the symbol is present:

```bash
$ grep helloFrom libmy_module.a.o
Binary file libmy_module.a.o matches
$ ar -p libmy_module.a | grep helloFrom
Binary file (standard input) matches
```

```bash
$ arm-none-eabi-nm libmy_module.a.o
         U __aeabi_unwind_cpp_pr0
00000002 r builtin.link_mode
00000001 r builtin.output_mode
00000000 r builtin.zig_backend
00000000 T helloFrom
00000000 r start.simplified_logic
```

### Issues

1. No header file was generated

```bash
$ zig build-lib src/root.zig \
  --name my_module \
  -static \
  -target thumb-freestanding-eabi \
  -mcpu cortex_m0plus \
  -femit-h=my_module.h
# No header file was generated
```
