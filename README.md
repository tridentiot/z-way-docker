# Docker container for Z-Way

This Docker container will run the latest Z-Way - the Smart Home controller software by Trident IoT.

> **_NOTE:_**  Please note that running Z-Way in Docker on MacOS or Windows is NOT supported, due to  Docker on Mac OS and on Windows not supporting passing USB from host to Docker container. On Windows use WSL instead.

It is possible to use a Unix socket or a TCP socket instead of accessing the hardware directly. Consult [Z-Way Documentation](https://tridentiot.github.io/z-way-developer-documentation/#RUNNING_Z_WAVE_SERIAL_API_OVER_TCP) for more information.

## Getting running the container

    ```sh
    docker run -it -p 8083 -v /data:/data --device /dev/ttyUSB0:/dev/ttyUSB0 ghcr.io/tridentiot/z-way-docker-debian-bookworm-amd64:main /opt/z-way-server/run.sh
    ```

Use `armhf` or `aarch64` instead of `amd64` for Raspberry Pi (Armhf) platforms.

Change `/dev/ttyUSB0` to `/dev/ttyAMA0` in the line above and in `Apps > Active Apps > Z-Wave Network Access > Serial port` if you are using an UART shield connected to Raspberry Pi UART pins.

All your files will be stored in the /data folder of your host.

## Building the container yourself

    ```sh
    git clone https://github.com/tridentiot/z-way-docker.git
    cd z-way-docker
    docker build --platform linux/amd64 -t z-way-docker:latest .
    docker run -it -p 8083 -v /data:/data --device /dev/ttyUSB0:/dev/ttyUSB0 --platform linux/amd64 z-way-docker:latest /opt/z-way-server/run.sh
    ```

> **_NOTE:_**  To access the hardware (/dev/tty*) and /data folder on Linux one might need to add `sudo` to the `docker run` command.

Use `linux/armhf` instead of `linux/amd64` for Raspberry Pi (Armhf) platforms.


## Setting up ports for your Z-Wave and Zigbee interfaces

You can find the right port using the following command:

    - **Linux**:

        ```sh
        ls /dev/tty*
        ```

    - **Windows** (using PowerShell):

        ```powershell
        Get-WmiObject Win32_SerialPort
        ```

    - **macOS**:

        ```sh
        ls /dev/cua*
        ```
Use `--device` multiple time if you need to pass two or more devices to the docker.
For example: `--device /dev/ttyUSB0:/dev/ttyUSB0 --device /dev/ttyUSB1:/dev/ttyUSB1`.
