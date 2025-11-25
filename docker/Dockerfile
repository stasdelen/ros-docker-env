ARG BASE_IMAGE=osrf/ros:melodic-desktop-full
FROM ${BASE_IMAGE}

WORKDIR /root/ws

# Install additional dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    jq  \
    git \
    vim \
    tmux \
    gdb \
    gdbserver \
    valgrind \
    kcachegrind \
    build-essential \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-melodic-plotjuggler-ros \
    ros-melodic-rviz \
    ros-melodic-rqt \
    ros-melodic-rqt-common-plugins \
    ros-melodic-tf2-tools \
    ros-melodic-roslint \
    ros-melodic-foxglove-bridge \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY image_scripts/.bash_aliases /root/.bash_aliases
RUN echo "if [ -f /root/.bash_aliases ]; then . /root/.bash_aliases; fi" >> /root/.bashrc

RUN echo "source /opt/ros/melodic/setup.bash" >> /root/.bashrc

COPY image_scripts/install_dev_env.sh /install_dev_env.sh
RUN /bin/bash -c "/install_dev_env.sh"

ENTRYPOINT ["tail", "-f", "/dev/null"]

