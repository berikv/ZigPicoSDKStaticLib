cmake_minimum_required(VERSION 3.13)

# initialize pico-sdk from GIT
# (note this can come from environment, CMake cache etc)
set(PICO_SDK_FETCH_FROM_GIT on)

# pico_sdk_import.cmake is a single file copied from this SDK
# note: this must happen before project()
include(pico_sdk_import.cmake)

project(mcui_example)

# Path to repo root
set(MY_MODULE_PROJECT_ROOT "${CMAKE_CURRENT_LIST_DIR}/..")
# Where to place the built library
# set(ZIG_OUT_DIR "${MY_MODULE_PROJECT_ROOT}/zig-out/lib")
set(MY_MODULE_LIB "${MY_MODULE_PROJECT_ROOT}/libmy_module.a")


# initialize the Raspberry Pi Pico SDK
pico_sdk_init()

add_custom_command(
  OUTPUT ${MY_MODULE_LIB}
  COMMAND zig build-lib src/root.zig
                --name my_module
                -static
                -target thumb-freestanding-eabi
                -mcpu cortex_m0plus
  WORKING_DIRECTORY "${MY_MODULE_PROJECT_ROOT}"
  DEPENDS "${MY_MODULE_PROJECT_ROOT}/src/root.zig"
  VERBATIM
)

add_custom_target(my_module_zig_lib ALL
  DEPENDS ${MY_MODULE_LIB}
)

add_executable(hello_world
    main.c
)

add_dependencies(hello_world my_module_zig_lib)

include_directories("./include")

target_link_libraries(hello_world
    "${MY_MODULE_LIB}"
    pico_stdlib
)

pico_add_extra_outputs(hello_world)
