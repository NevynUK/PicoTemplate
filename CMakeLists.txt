cmake_minimum_required(VERSION 3.13)

include(pico_sdk_import.cmake)

project(projectname C CXX ASM)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

set(PICO_CXX_ENABLE_EXCEPTIONS 1)

pico_sdk_init()

add_executable(${PROJECT_NAME}
    src/main.cpp
)

pico_set_program_name(${PROJECT_NAME} "projectname")
pico_set_program_version(${PROJECT_NAME} "0.1")

target_link_libraries(${PROJECT_NAME} pico_stdlib)

#
#   Taken from the Pico examples.
#
add_compile_options(-Wall
        -Wno-format          # int != int32_t as far as the compiler is concerned because gcc has int32_t as long int
        -Wno-unused-function # we have some for the docs that aren't called
        )
if (CMAKE_C_COMPILER_ID STREQUAL "GNU")
    add_compile_options(-Wno-maybe-uninitialized)
endif()

#
#   Add additional libraries here, candidates include:
#       hardware_spi, hardware_i2c, hardware_dma, hardware_pio, hardware_timer, hardware_watchdog, hardware_clocks
#
# target_link_libraries(${PROJECT_NAME} hardware_spi)

#
#   Uncomment the following two lines to enable serial over USB.
#
# pico_enable_stdio_usb(${PROJECT_NAME} 1)
# pico_enable_stdio_uart(${PROJECT_NAME} 0)

#
#   Uncomment the following two lines to enable serial over GPIO UART.
#
pico_enable_stdio_usb(${PROJECT_NAME} 0)
pico_enable_stdio_uart(${PROJECT_NAME} 1)

pico_add_extra_outputs(${PROJECT_NAME})
