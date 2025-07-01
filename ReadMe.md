
# Using Zig to build a cortex-m0+ static library

## Using zig build-lib

```zig
// src/root.zig
pub export fn fourtyTwo() u32 {
    return 42;
}
```

```bash
$ zig build-lib src/root.zig \
  --name my_module \
  -static \
  -target thumb-freestanding-none \
  -mcpu cortex_m0plus

$ ls
libmy_module.a libmy_module.a.o
```

The .o file looks to be a valid ELF object file:

```bash
$ file libmy_module.a.o
libmy_module.a.o: ELF 32-bit LSB relocatable, ARM, EABI5 version 1 (SYSV), with debug_info, not stripped
```

But the archive looks weird:

```bash
$ ar -t libmy_module.a
/
//
/0
```

The archive seems to contain the library though:

```bash
$ ar -p libmy_module.a | strings
fourtyTwo
...
zig 0.14.0
...
cortex-m0plus
```

And the symbol is present:

```bash
$ grep fourtyTwo libmy_module.a.o
Binary file libmy_module.a.o matches
$ ar -p libmy_module.a | grep fourtyTwo
Binary file (standard input) matches
```

```bash
$ arm-none-eabi-nm libmy_module.a.o
         U __aeabi_unwind_cpp_pr0
00000002 r builtin.link_mode
00000001 r builtin.output_mode
00000000 r builtin.zig_backend
00000000 T fourtyTwo
00000000 r start.simplified_logic
```

### Issues

1. No header file was generated
