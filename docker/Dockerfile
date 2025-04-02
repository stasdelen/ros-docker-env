FROM osrf/ros:noetic-desktop-full

ARG USER_ID=1000
ARG GROUP_ID=1000
ARG USER_NAME=rosuser

RUN apt-get update && apt-get install -y libglvnd-dev

RUN groupadd -g $GROUP_ID $USER_NAME && \
    useradd -u $USER_ID -g $USER_NAME -ms /bin/bash $USER_NAME && \
    usermod -aG sudo $USER_NAME && \
    usermod -aG $GROUP_ID $USER_NAME && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER $USER_NAME
WORKDIR /home/$USER_NAME
