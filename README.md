# ros-docker-env

This repository implements a Docker-based ROS (ROS 1 Melodic) development environment with GUI support, DevContainer/DevPod integrations, and a ready-to-use catkin workspace helper Makefile.

## Prerequisites

- Docker with access to the host X11 socket for GUI forwarding.
- Optional: NVIDIA Container Toolkit if you plan to use the GPU compose file.
- DevPod or VS Code (for DevContainer workflows).

## Quickstart: Build and Run

The compose files live in `docker/` and mount the repo `workspace/` into the container at `/root/ws`.

```bash
# CPU-only (default)
docker compose -f docker/docker-compose.yml build
docker compose -f docker/docker-compose.yml up -d

# GPU-enabled (requires NVIDIA runtime)
docker compose -f docker/docker-compose.gpu.yml build
docker compose -f docker/docker-compose.gpu.yml up -d
```

Both compose files forward the host X11 socket, `/dev`, and a local `config/` directory so GUI tools like RViz and Gazebo can run inside the container.【F:docker/docker-compose.yml†L1-L24】【F:docker/docker-compose.gpu.yml†L1-L28】

Attach to the running container:

```bash
docker exec -it ros-dev bash
```

Stop and remove the container when you're done:

```bash
docker compose -f docker/docker-compose.yml down
# or docker compose -f docker/docker-compose.gpu.yml down
```

## Modifying the Environment

- **Base image**: Change `BASE_IMAGE` in `docker/Dockerfile` to another ROS desktop image (e.g., newer ROS distributions).【F:docker/Dockerfile†L1-L3】
- **Packages and tools**: Add/remove apt packages in the two install blocks to customize debugging, visualization, or ROS utilities.【F:docker/Dockerfile†L7-L23】
- **Shell tools and Neovim**: Update `image_scripts/install_dev_env.sh` if you want to change the bundled dotfiles, Neovim installation, or extra CLI utilities.【F:image_scripts/install_dev_env.sh†L1-L37】
- **Workspace mount**: Adjust the volumes in the compose files if your ROS workspace lives elsewhere or if you want to mount additional host folders (e.g., datasets).【F:docker/docker-compose.yml†L17-L24】

## DevContainer and DevPod

- The root `.devcontainer/devcontainer.json` points to the compose service `ros-dev` and uses `/root` as the workspace folder, so VS Code or DevPod reuses the same container defined above.【F:.devcontainer/devcontainer.json†L1-L7】
- A local feature (`.devcontainer/local-feature`) installs Neovim, FZF, Python 3.8, and convenience tools when building via DevContainers.【F:.devcontainer/local-feature/install.sh†L1-L27】

### Launch with DevPod

```bash
devpod up . --dotfiles https://github.com/<YOUR_USER>/dotfiles
# specify an IDE, e.g. Zed
devpod up . --ide zed

# stop the environment (the name defaults to the parent folder)
devpod stop ros-docker-env
```

### Using VS Code Dev Containers

Open the folder in VS Code and choose **Reopen in Container**. Ensure Docker is running locally; VS Code will build the image using `docker/docker-compose.yml` and attach to the `ros-dev` service.

## Bash Aliases and Helper Functions

The image copies `image_scripts/.bash_aliases` into the container and enables it via `.bashrc`. Key helpers include:

- `set_ros_master <host> [port]` – Point to a remote or local ROS master (defaults to `localhost:11311`).【F:image_scripts/.bash_aliases†L4-L20】
- `rviz_namespaced <config> <namespace>` / `rqt_namespaced <namespace>` – Launch RViz/RQT with TF and topics remapped to a namespace.【F:image_scripts/.bash_aliases†L22-L59】
- `kill_sim` and `killgazeboros` – Quickly terminate gazebo/ros processes from the shell.【F:image_scripts/.bash_aliases†L61-L67】
- `build_release` / `build_debug` – Shorthand for `catkin_make_isolated` with sensible defaults for Release or Debug builds.【F:image_scripts/.bash_aliases†L69-L93】
- `gen_compile_db` – Merge `compile_commands.json` files from `build_isolated` into a single database at the workspace root for better editor integration.【F:image_scripts/.bash_aliases†L95-L115】

## ROS Workspace Make Targets

Inside the mounted `workspace/` folder you'll find a `Makefile` that wraps `catkin_make_isolated` and `catkin_make`:

- `make isolated <pkg1> [pkg2 …]` – Release isolated build of packages and dependencies.
- `make isolated_debug <pkg1> [pkg2 …]` – Debug isolated build.
- `make release <pkg1> [pkg2 …]` – Release build using `catkin_make` with installs enabled.【F:workspace/Makefile†L1-L40】

Run these commands from `/root/ws` inside the container. Each target requires at least one package name and emits usage help if none is provided.

## GUI Usage Tips

- Ensure your host X server allows local connections (e.g., `xhost +local:`) before starting the container.
- The compose files mount `/tmp/.X11-unix` and forward `DISPLAY`/`XDG_RUNTIME_DIR` so RViz, Gazebo, and PlotJuggler work out of the box.

## Troubleshooting

- If GUI applications fail, verify `DISPLAY` and `XDG_RUNTIME_DIR` match your host values and that the X11 socket is mounted.
- For GPU issues, confirm `nvidia-smi` works on the host and that the NVIDIA Container Toolkit is installed.

