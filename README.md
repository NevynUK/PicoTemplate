# PicoTemplate

![Main Branch](https://github.com/NevynUK/PicoTemplate/actions/workflows/build.yaml/badge.svg)

This repository contains a template Raspberry Pi Pico project along with some shell scripts to build the project.  The default applications (both Pico and Pico W) perform the same actions:

* Configure standard output to be sent over USB
* Blink the on board LED

## Prerequisites

It is assumed that the Pico SDK is installed along with OpenOCD for the Raspberry Pi Pico.  The SDK and OpenOCD should be installed at the same level in order for the flash scripts to be used unmodified.  So the directory structure should look something link:

```
| Pi-Pico
+--- Pico-SDK
+--- OpenOCD
```

where `PICO_SDK_PATH` has been set to `Pi-Pico/Pico-SDK`

Instructions for the installation of the Pico SDK and OpenOCD can be found in the [Getting started with Raspberry Pi Pico](https://datasheets.raspberrypi.com/pico/getting-started-with-pico.pdf).

## Configuring the Project

By default, the system is configured with a simple GPIO example and will generate an application called `projectname`.  The first step is to configure the system and select a name for your project using the `configure.sh` script.  Execute the following command changing `MyProject` to the name of your application using the repository default board type (Pico):

```bash
./configure.sh --name=MyProject
```

It is possible to change the board type using the `-b` or `--board` option:

```bash
./configure.sh --name=MyProject --board=picow
```

Two board types are supported:

* pico
* picow

## Building the Application

The application can be built by executing the command `./build.sh`.  At the end of the process you will find that the `build` directory contains the ELF and UF2 files for your application.

You can also force the system to be fully rebuilt by executing the command `./build.sh --rebuild`.

## Docker

The system also supports building the system using a Docker container.  Two scripts are provided to support this:

* `docker-build.sh`
* `docker-run.sh`

### docker-build.sh

This file contains the command to build the docker container called `pico-build`.  This contains all of the assets needed to build a Pico project including the Pico SDK.

### docker-run.sh

This file starts the docker container in interactive mode, from there the system can be configured and built using the `configure.sh` and `build.sh` scripts.

## Flash the Board

The application binary can be written to the board using the `flash.sh` script.  This will use the `openocd` application to write the compiled code to the Pico using a Pico set up as a debug probe.

## Debugging

Debugging support is available through VS Code.  The build script can build a debug version of the code using the command `build.sh --debug`.  This configuration can be used when using VS Code as a debug environment.  For more information on the background see:

* [Debugging NuttX on the Raspberry Pi Pico](https://blog.mark-stevens.co.uk/2023/06/debugging-nuttx-on-the-raspberry-pi-pico/)
* [VSCode Debugging with NuttX and Raspberry Pi PicoW](https://blog.mark-stevens.co.uk/2023/06/vscode-debugging-with-nuttx-and-raspberry-pi-picow/)

## Acknowledgements

This repository has been inspired by several others on github:

[Raspberry Pi Pico Examples](https://github.com/raspberrypi/pico-examples)
[Raspberry Pi Pico Template](https://github.com/cathiele/raspberrypi-pico-cpp-template)
