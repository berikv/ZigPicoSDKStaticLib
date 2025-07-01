
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

The [pico](pico/) directory contains a bare-bones [pico-sdk](https://github.com/raspberrypi/pico-sdk) project, similar to [the hello usb example](https://github.com/raspberrypi/pico-examples/blob/master/hello_world/usb/hello_usb.c). The [CMakeLists.txt](pico/CMakeLists.txt) is set up to call `zig build-lib` on [root.zig](src/root.zig), and link the result. [main.c](pico/src/main.c) calls helloFrom() and prints the result to the USB serial port.

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
