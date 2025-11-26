ARG BASE_IMAGE=osrf/ros:melodic-desktop-full
FROM ${BASE_IMAGE}

WORKDIR /root/ws

ARG INSTALL_DEV_ENV=true

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

# Install additional development tools if requested
RUN if [ "${INSTALL_DEV_ENV}" = "true" ]; then \
    apt-get update; \
    apt-get install -y --no-install-recommends software-properties-common fuse libfuse2 curl unzip xclip less; \
  else \
    echo "Skipping dev environment install (INSTALL_DEV_ENV=${INSTALL_DEV_ENV})"; \
  fi

# Install python3.8
RUN if [ "${INSTALL_DEV_ENV}" = "true" ]; then \
    add-apt-repository ppa:deadsnakes/ppa -y; \
    apt-get update; \
    apt-get install -y --no-install-recommends python3.8 python3.8-venv python3-venv; \
  fi

# Install neovim
RUN if [ "${INSTALL_DEV_ENV}" = "true" ]; then \
    curl -Lo /tmp/nvim.appimage https://github.com/neovim/neovim-releases/releases/download/v0.11.0/nvim-linux-x86_64.appimage; \
    chmod +x /tmp/nvim.appimage; \
    cd /tmp; \
    ./nvim.appimage --appimage-extract; \
    mv squashfs-root /opt/nvim; \
    ln -s /opt/nvim/AppRun /usr/bin/nvim; \
    rm /tmp/nvim.appimage; \
  fi

# Install dotfiles
RUN if [ "${INSTALL_DEV_ENV}" = "true" ]; then \
    git clone https://github.com/stasdelen/dotfiles.git /root/dotfiles; \
    chmod a+x /root/dotfiles/install.sh; \
    /root/dotfiles/install.sh; \
  fi

# Install fzf
RUN if [ "${INSTALL_DEV_ENV}" = "true" ]; then \
    git clone --depth 1 https://github.com/junegunn/fzf.git /root/fzf; \
    /root/fzf/install --key-bindings --completion --update-rc; \
  fi

# Setup neovim packages
RUN if [ "${INSTALL_DEV_ENV}" = "true" ]; then \
    nvim --headless "+Lazy! sync" +qa; \
    nvim --headless "+MasonUpdate" +qa; \
    nvim --headless "+MasonToolsUpdateSync" +qa; \
    nvim --headless "+TSUpdateSync" +qa; \
  fi

# Install additinal deps
RUN if [ "${INSTALL_DEV_ENV}" = "true" ]; then \
    apt-get update; \
    apt-get install -y --no-install-recommends libompl-dev; \
  fi

RUN if [ "${INSTALL_DEV_ENV}" = "true" ]; then \
    apt-get clean && rm -rf /var/lib/apt/lists/*; \
  fi

COPY image_scripts/.bash_aliases /root/.bash_aliases
RUN echo "if [ -f /root/.bash_aliases ]; then . /root/.bash_aliases; fi" >> /root/.bashrc

RUN echo "source /opt/ros/melodic/setup.bash" >> /root/.bashrc

ENTRYPOINT ["tail", "-f", "/dev/null"]
