# PicoTemplate

This repository contains a template Raspberry Pi Pico project along with some shell scripts to build the project.

![Main Branch](https://github.com/NevynUK/PicoTemplate/actions/workflows/build.yml/badge.svg)

## Prerequisites

It is assumed that the Pico SDK is installed along with OpenOCD for the Raspberry Pi Pico.  The SDK and OpenOCD should be installed at the same level in order for the flash scripts to be used unmodified.  So the directory structure should look something link:

```
| Pi-Pico
+--- Pico-SDK
+--- OpenOCD
```

where `PICO_SDK_PATH` has been set to `Pi-Pico/Pico-SDK`

Instructions for the installation of the Pido SDK and OpenOCD can be found in the [Getting started with Raspberry Pi Pico](https://datasheets.raspberrypi.com/pico/getting-started-with-pico.pdf).

## Configuring the Project

By default, the system is configured with a simple GPIO example and will generate an application called `projectname`.  The first step is to configure the system and select a name for your project using the `configure.sh` script.  Execute the following command changing `MyProject` to the name of your application;

```bash
./configure.sh --name=MyProject
```

## Building the Application

The application can be built by executing the command `./build.sh`.  At the end of the process you will find that the `build` directory contains the ELF and UF2 files for your application.

You can also force the system to be fully rebuilt by executing the command `./build.sh --rebuild`.

## Flash the Board

The application binary can be written to the board using the `flash.sh` script.  This will use the `openocd` application to write the compiled code to the Pico using a Pico set up as a debug probe.

## Debugging

Debugging support is available through VS Code.  The build script can build a debug version of the code using the command `build.sh --debug`.  This configuration will be used when using VS Code as a debug environment.
