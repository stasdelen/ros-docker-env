#!/bin/bash

# 1. XAuth Setup (More Robust Handling)
if ! command -v xauth &> /dev/null; then
    echo "[ERROR] command xauth not found. Please install using your package manager."
    exit 1
fi

XAUTH=/tmp/.docker.xauth
rm -f $XAUTH  # Clear any existing file

# Generate XAuth entry with proper permissions
if [ -z "$DISPLAY" ]; then
    DISPLAY=:0  # Fallback display if not set
    echo "[WARNING] Falling back to display $DISPLAY"
fi

xauth_list=$(xauth -b nlist $DISPLAY 2>/dev/null | sed -e 's/^..../ffff/') 
if [ -n "$xauth_list" ]; then
    echo "$xauth_list" | xauth -f $XAUTH nmerge - 2>/dev/null
else
    # Fallback: Create minimal XAuth entry
    echo "[WARNING] Falling back to minimal XAuth entry."
    touch $XAUTH
    xauth -f $XAUTH add $DISPLAY . $(mcookie)
fi
chmod 644 $XAUTH

echo "[INFO] Generated Xauth entry in: $XAUTH"

# Get the user's UID and runtime directory
USER_ID=$(id -u)
XDG_RUNTIME_DIR="/run/user/${USER_ID}"

# Check if the runtime directory exists
if [ ! -d "$XDG_RUNTIME_DIR" ]; then
    echo "[ERROR] XDG_RUNTIME_DIR ($XDG_RUNTIME_DIR) doesn't exist and author does not know what to do."
    exit 1
fi

echo "[INFO] Found XDG_RUNTIME in: $XDG_RUNTIME_DIR"

# 2. GPU Detection and Configuration
GPU_CONFIG=""
NVIDIA_ENV=""
if command -v nvidia-smi &> /dev/null; then
    echo "[INFO] Found nvidia GPU generating flags for it."
    GPU_CONFIG="    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]"
    NVIDIA_ENV="
      - NVIDIA_DRIVER_CAPABILITIES=all
      - __NV_PRIME_RENDER_OFFLOAD=1
      - __GLX_VENDOR_LIBRARY_NAME=nvidia"
else
  echo "[WARNING] NVIDIA drivers not found - using CPU mode."
fi

# Generate docker-compose.yml
cat > docker-compose.yml <<EOF
# Autogenerated docker compose file.
services:
  ros-dev:
    image: ros-dev
    container_name: ros-dev
    build:
      context: .
      dockerfile: Dockerfile
    stdin_open: true
    tty: true
    network_mode: host
    ipc: host
    privileged: true
    environment:
      - DISPLAY=$DISPLAY
      - XAUTHORITY=$XAUTH
      - QT_X11_NO_MITSHM=1
      - QT_QPA_PLATFORM=xcb
      - XAUTHORITY=/root/.Xauthority
      - XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR}
$NVIDIA_ENV
    volumes:
      - /tmp/.X11-unix:/tmp/.X11-unix
      - ${XDG_RUNTIME_DIR}:${XDG_RUNTIME_DIR}
      - ${XAUTH}:${XAUTH}:rw
      - /dev/dri:/dev/dri
      - ../.:/home/rosuser/catkin_ws
      - /home/rosuser/catkin_ws/docker
$GPU_CONFIG

EOF

echo "[INFO] docker-compose.yml has been generated."
echo "[INFO] You can now start the container with: docker compose up -d"
echo "[INFO] Or for interactive shell: docker compose run ros-dev bash"
