FROM fedora:43

ARG USER=claude
ARG UID=1000
ARG GID=1000

# System packages: dev tools, build deps, Python, Node
RUN dnf install -y \
  git \
  curl \
  jq \
  ripgrep \
  fd-find \
  procps-ng \
  gcc gcc-c++ make \
  openssl-devel pkg-config \
  python3 python3-pip python3-devel \
  nodejs npm \
  && dnf clean all

# Create user
RUN groupadd -g $GID $USER && \
    useradd -m -u $UID -g $GID $USER

USER $USER
WORKDIR /home/$USER

# Rust via rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/home/$USER/.cargo/bin:$PATH"

# uv (Python project/package manager)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/home/$USER/.local/bin:$PATH"

# Poetry via uv
RUN uv tool install poetry

# Claude Code via native installer
RUN curl -fsSL https://claude.ai/install.sh | bash
ENV PATH="/home/$USER/.claude/bin:$PATH"

# Pre-create directories for --userns=keep-id compatibility
RUN mkdir -p /home/$USER/.local/{state,share,cache}

CMD ["claude"]
