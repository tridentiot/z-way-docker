FROM debian:bookworm

WORKDIR /opt/z-way-server

ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]

# Block zbw key request
RUN mkdir -p /etc/zbw/flags && touch /etc/zbw/flags/no_connection

RUN apt-get update && \
    apt-get install -qqy --no-install-recommends \
    dirmngr apt-transport-https gnupg wget lsb-release \
    ca-certificates curl \
    wget procps iproute2 openssh-client openssh-server sudo logrotate && \
    apt-get clean && rm -rf /var/lib/apt/lists/*


# Install z-way-server and zbw
RUN distro=$(lsb_release -a 2>/dev/null | grep Codename | awk '{print $2}') && \
    distro_id=$(lsb_release -a 2>/dev/null | grep "Distributor ID" | awk '{print $3}' | tr '[:upper:]' '[:lower:]') && \
    architecture=$(uname -m) && \
    if [ "$architecture" == "aarch64" -o "$architecture" == "armv7l" ]; then arch_tag="[arch=armhf]"; arch_apt=":armhf"; dpkg --add-architecture armhf; fi && \
    if [ "$architecture" == "aarch64" -o "$architecture" == "armv7l" -o "$architecture" == "armhf" ]; then zbw_distro_id="raspbian"; else zbw_distro_id="${distro_id}"; fi && \
    wget "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x79006366B9B20A6B4D7E1C27AD242992ACAB4528" -O /etc/apt/trusted.gpg.d/tridentiot.asc && \
    wget "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xbc04cd36834c6ad41c8b9eb15b2f88a91611e683" -O /etc/apt/trusted.gpg.d/z-wave-me.asc && \
    echo "deb ${arch_tag} https://tridentiot.github.io/apt-repository/${distro_id} ${distro} main" >/etc/apt/sources.list.d/tridentiot.list && \
    echo "deb ${arch_tag} https://repo.z-wave.me/z-way/${zbw_distro_id} ${distro} main" >/etc/apt/sources.list.d/z-wave-me.list && \
    apt-get update -y && \
    apt-get install -y z-way-server${arch_apt} zbw${arch_apt} && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN rm -f /opt/z-way-server/automation/storage/*

# Unblock zbw
RUN rm /etc/zbw/flags/no_connection
RUN echo "zbox" > /etc/z-way/box_type

COPY rootfs/ /

# Add the initialization script
RUN chmod +x /opt/z-way-server/run.sh

EXPOSE 8083

CMD /opt/z-way-server/run.sh
