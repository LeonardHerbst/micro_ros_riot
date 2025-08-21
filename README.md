# micro-ROS on RIOT
This repository is pulled by the RIOT build system to build micro-ROS as a statically linked library for RIOT.
It is designed to be used with the RIOT build system and is not intended for use outside of that context.
It has been tested with RIOT 2025.04.

## Overview
This repository builds micro-ROS as a statically linked library for RIOT.  
The build process uses the colcon build system and follows these steps:

1. Clone the micro-ROS repository and its dependencies.
2. Create a Python virtual environment and install colcon along with the other required dependencies.
3. Build the ament tools for the host system using colcon, and install them into a dedicated workspace.
4. Build micro-ROS for the target system using colcon and the ament tools, then install it into its own workspace.
5. Combine all build artifacts into a single statically linked library.

## Dependencies
micro-ROS is built using colcon.  
Colcon and all required Python dependencies are automatically installed inside a virtual environment.  
Additional dependencies are fetched via Git, built with colcon, and installed into a colcon workspace.

## Known Limitations/Issues
The Ament tools required to build micro-ROS are always compiled for the host using gcc,
regardless of the selected target toolchain.

Micro-ROS is configured using a colcon meta file (json). This requires a "translation" of kconfig output into a colcon meta file.
At the moment, this translation is done manually via search and replace on a template file.