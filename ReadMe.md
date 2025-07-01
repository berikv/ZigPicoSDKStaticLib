
# A Zig static library demo for the Raspberry Pi Pico SDK

A minimal Zig static-library and Pico SDK example showing how to call into Zig from C on a Cortex-M0+ microcontroller.

## Overview

This repository demonstrates how to compile Zig into a static library, that can be linked by a Pico SDK project.

The Zig code is minimal:

```zig
// src/root.zig
const zig = "Zig";
pub export fn helloFrom() usize {
    return @intFromPtr(zig);
}
```

And C can call it like this:

```c
// Function declaration, see note below.
size_t helloFrom(void);

char *from = (char *)helloFrom();
printf("Hello from %s!\n", from);
```

The [pico](pico/) folder contains a minimal [Raspberry Pi Pico SDK](https://github.com/raspberrypi/pico-sdk) project whose [CMakeLists.txt](pico/CMakeLists.txt) does the following:

1. Builds the zig standard library:

    ```bash
    zig build-lib src/root.zig \
                    --name my_module \
                    -static \
                    -target thumb-freestanding-eabi \
                    -mcpu cortex_m0plus
    ```

2. Links `libmy_module.a` into the Pico firmware
3. Saves the firmware in different formats

The application code is in [main.c](pico/src/main.c), which:

- Includes [my_module.h](pico/include/my_module.h), which provides the forward declaration for `helloFrom()`.
- Calls `helloFrom()` and prints the returned string over USB serial.

> **Note:** As of Zig 0.14.0, `zig build-lib` does not generate a C header. You must manually declare the API in a header file such as `pico/include/my_module.h`.

## Quickstart

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
- Save rp pico compatible binary formats (uf2, bin, elf, hex) to [pico/build/](pico/build/)

### Flash

To flash the binary on a rp pico board:

- Hold the boot button while powering up the pico
- Check that the rp pico is mounted as a usb drive
- Copy the `pico/build/hello_world.uf2` to the pico usb drive

Now the pico will print the message "Hello from Zig!" on the USB serial port.

### Monitor

Use a serial port tool such as Arduino's serial monitor or the VSCode Teleport plugin monitor the usb serial port.
When set up correctly, you should see the message "Hello from Zig!" appear every second on the serial port.
