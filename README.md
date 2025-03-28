# Docker container for Z-Way

This Docker container will run the latest Z-Way - the Smart Home controller software by Trident IoT.

## Getting running the container

    ```sh
    docker build --platform linux/amd64 -t z-way-docker:latest .
    docker run -it -p 8083 -v /data:/data --device /dev/ttyUSB0:/dev/ttyUSB0 --platform linux/amd64 z-way-docker:latest /opt/z-way-server/run.sh
    ```

Use `linux/armhf` instead of `linux/amd64` for Raspberry Pi (Armhf) platforms.

Change `/dev/ttyUSB0` to `/dev/ttyAMA0` in the line above and in `Apps > Active Apps > Z-Wave Network Access > Serial port` if you are using an UART shield connected to Raspberry Pi UART pins.

All your files will be stored in the /data folder of your host.

## Building the container yourself

    ```sh
    git clone https://github.com/tridentiot/z-way-docker.git
    cd z-way-docker
    ```

## Setting up ports for your Z-Wave and Zigbee interfaces

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

Update the `docker-compose.yml` file with the correct device paths if necessary.

Rebuild and start the container:

    ```sh
    docker compose build
    docker compose up
    ```
