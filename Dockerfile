FROM debian:bookworm-slim

ARG USER=claude
ARG UID=1000

RUN apt-get update && apt-get install -y \
    curl \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -u $UID $USER

USER $USER
WORKDIR /home/$USER

RUN curl -fsSL https://claude.ai/install.sh | bash
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

ENV PATH="/home/$USER/.local/bin:$PATH"

CMD ["claude"]
