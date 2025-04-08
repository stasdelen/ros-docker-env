# ros-docker-env
This repository implements a ROS Docker+Devpod Development Environement with Desktop GUI Support.

## Docker

The `docker/` directory contains the core files necessary to build and manage a development environment using Docker and Docker Compose. This setup is designed for GPU-enabled systems and supports X11 GUI forwarding, making it suitable for simulation and visualization tools like Gazebo and RViz.

### Contents

- **Dockerfile**  

    Defines the ROS development image based on `osrf/ros:melodic-desktop-full`. It installs common ROS navigation and simulation packages such as `turtlebot3`, `gazebo`, and `move_base`. It also sets up a non-root user (`rosuser`) and configures environment variables needed for development.

    ⚠️ Please note that the this container is just an example an can be configured for your needs. I just installed example stuff to be able to test the environment. However, you have to add the user (`rosuser`) in order to be able to use GUI related stuff securely. It uses `Xauth` to authorize the connection to the X server, rather than exposing X server to network causing security risks.

- **generate-compose.bash**  
  A utility script that generates a `docker-compose.yml` file dynamically. It:
  - Configures X11 and XAuth for GUI forwarding.
  - Detects GPU hardware and sets up appropriate Docker runtime flags (e.g., NVIDIA).
  - If no NVIDIA GPU is detected, the container automatically falls back to CPU-based rendering to ensure compatibility.
  - Mounts required host directories including `/workspace`, `/tmp/.X11-unix`, and runtime paths.

- **Makefile**  
  Provides convenience commands to streamline common Docker workflows:
  - `make compose` – Generates the docker-compose file.
  - `make build` – Builds the Docker image.
  - `make run` – Runs the container with display forwarding and GPU support.
  - `make attach` – Attaches an interactive shell to the running container.
  - `make stop` – Stops the container.
  - `make env` – Creates a `.env` file with user and group IDs for proper permission mapping inside the container.

### Usage

To set up and launch the ROS development container:

```bash
make env
make compose
make build
make run
```

