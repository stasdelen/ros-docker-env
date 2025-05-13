FROM osrf/ros:noetic-desktop-full

ARG USER_ID=1000
ARG GROUP_ID=1000
ARG USER_NAME=rosuser

WORKDIR /workspace

# Install additional dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    git \
    libxml2-dev \
    libxslt-dev \
    valgrind \
    kcachegrind \
    build-essential \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-noetic-amcl \
    ros-noetic-base-local-planner \
    ros-noetic-map-server \
    ros-noetic-move-base \
    ros-noetic-navfn \
    ros-noetic-plotjuggler-ros \
    ros-noetic-turtlebot3 \
    ros-noetic-turtlebot3-simulations \
    ros-noetic-turtlebot3-navigation \
    ros-noetic-gazebo-ros \
    ros-noetic-gazebo-plugins \
    ros-noetic-tf \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN groupadd -g $GROUP_ID $USER_NAME && \
    useradd -u $USER_ID -g $USER_NAME -ms /bin/bash $USER_NAME && \
    usermod -aG sudo $USER_NAME && \
    usermod -aG $GROUP_ID $USER_NAME && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set up environment variables
ENV ROS_DISTRO=noetic
ENV ROS_VERSION=1
ENV TURTLEBOT3_MODEL=waffle
RUN chown -R $USER_NAME:$GROUP_ID /workspace

USER $USER_NAME

RUN echo "source /opt/ros/noetic/setup.bash" >> /home/$USER_NAME/.bashrc && \
    echo "source /workspace/devel/setup.bash" >> /home/$USER_NAME/.bashrc

# Expose ROS master port and Gazebo ports
EXPOSE 11311 11345

CMD ["roscore"]
