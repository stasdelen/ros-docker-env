ARG BASE_IMAGE=osrf/ros:melodic-desktop-full
FROM ${BASE_IMAGE}

WORKDIR /root/ws

ARG INSTALL_DEV_ENV=true

# Install essential build tools
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

# Install visualization tools
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
    apt-get clean && rm -rf /var/lib/apt/lists/*; \
  else \
    echo "Skipping dev environment install (INSTALL_DEV_ENV=${INSTALL_DEV_ENV})"; \
  fi

# Install python3.8
RUN if [ "${INSTALL_DEV_ENV}" = "true" ]; then \
    add-apt-repository ppa:deadsnakes/ppa -y; \
    apt-get update; \
    apt-get install -y --no-install-recommends python3.8 python3.8-venv python3-venv; \
    apt-get clean && rm -rf /var/lib/apt/lists/*; \
  fi

# Install neovim
RUN if [ "${INSTALL_DEV_ENV}" = "true" ]; then \
    curl -Lo /tmp/nvim.tar.gz https://github.com/neovim/neovim-releases/releases/download/v0.11.6/nvim-linux-x86_64.tar.gz; \
    rm -rf /opt/nvim; \
    mkdir -p /opt; \
    tar -C /opt -xzf /tmp/nvim.tar.gz; \
    mv /opt/nvim-linux-x86_64 /opt/nvim; \
    ln -sf /opt/nvim/bin/nvim /usr/bin/nvim; \
    rm /tmp/nvim.tar.gz; \
    command -v nvim; \
    nvim --version; \
  fi

# Install dotfiles
RUN if [ "${INSTALL_DEV_ENV}" = "true" ]; then \
    git clone --resursive https://github.com/stasdelen/dotfiles.git /root/dotfiles; \
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

# Copy some usefull aliases
COPY image_scripts/.bash_aliases /root/.bash_aliases
RUN echo "if [ -f /root/.bash_aliases ]; then . /root/.bash_aliases; fi" >> /root/.bashrc

RUN echo "source /opt/ros/melodic/setup.bash" >> /root/.bashrc

ENTRYPOINT ["tail", "-f", "/dev/null"]
