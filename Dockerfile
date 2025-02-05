# Use the official ROS Melodic base image
FROM osrf/ros:melodic-desktop-full

# Set the working directory
WORKDIR /workspace

# Install additional dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    git \
    libxml2-dev \
    libxslt-dev \
    python3 \
    python3-pip \
    ros-melodic-amcl \
    ros-melodic-base-local-planner \
    ros-melodic-map-server \
    ros-melodic-move-base \
    ros-melodic-navfn \
    ros-melodic-plotjuggler-ros \
    ros-melodic-rosbag-editor \
    ros-melodic-turtlebot3 \
    ros-melodic-turtlebot3-simulations \
    ros-melodic-turtlebot3-navigation \
    ros-melodic-gazebo-ros \
    ros-melodic-gazebo-plugins \
    ros-melodic-tf \
    valgrind \
    kcachegrind \
    vim \
    python3-rosdep \
    python3-rosinstall-generator \
    python3-vcstool \
    build-essential \
    python3-opencv \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip3 install --no-cache-dir \
    setuptools \
    catkin-tools \
    numpy \
    matplotlib \
    scikit-image

COPY workspace /workspace

# Set up environment variables
ENV ROS_DISTRO=melodic
ENV ROS_VERSION=1
ENV ROS_PYTHON_VERSION=3

# Set TurtleBot3 model to burger by default
ENV TURTLEBOT3_MODEL=burger

RUN echo "source /opt/ros/melodic/setup.bash" >> /root/.bashrc && \
    echo "source /workspace/turtle_ws/devel/setup.bash" >> /root/.bashrc

# Set catkin python version on bashrc
RUN echo "export ROS_PYTHON_VERSION=3" >> /root/.bashrc

# Expose ROS master port and Gazebo ports
EXPOSE 11311 11345

# Set entry point to start ROS
CMD ["/bin/bash"]
