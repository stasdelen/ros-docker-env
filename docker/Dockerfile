FROM osrf/ros:melodic-desktop-full

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
    ros-melodic-amcl \
    ros-melodic-navigation \
    ros-melodic-base-local-planner \
    ros-melodic-map-server \
    ros-melodic-move-base \
    ros-melodic-navfn \
    ros-melodic-plotjuggler-ros \
    ros-melodic-turtlebot3 \
    ros-melodic-turtlebot3-simulations \
    ros-melodic-turtlebot3-navigation \
    ros-melodic-gazebo-ros \
    ros-melodic-gazebo-plugins \
    ros-melodic-tf \ 
    ros-melodic-fake-localization \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN groupadd -g $GROUP_ID $USER_NAME && \
    useradd -u $USER_ID -g $USER_NAME -ms /bin/bash $USER_NAME && \
    usermod -aG sudo $USER_NAME && \
    usermod -aG $GROUP_ID $USER_NAME && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN apt-get update && apt-get install -y --no-install-recommends \
    liblua5.1-0-dev \
    lua5.1 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN chown -R $USER_ID:$GROUP_ID /workspace

# Set up environment variables
ENV ROS_DISTRO=melodic
ENV ROS_VERSION=1
ENV TURTLEBOT3_MODEL=waffle

USER $USER_NAME

RUN echo "source /opt/ros/melodic/setup.bash" >> /home/$USER_NAME/.bashrc && \
    echo "source /workspace/devel/setup.bash" >> /home/$USER_NAME/.bashrc

# Expose ROS master port and Gazebo ports
EXPOSE 11311 11345

CMD ["roscore"]
