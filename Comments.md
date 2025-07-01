# Comments

Personal notes and comments while making progress.

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
