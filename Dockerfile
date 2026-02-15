FROM python:3.11-slim-trixie

ARG DEBIAN_FRONTEND=noninteractive

# Metadata
LABEL maintainer="ozan.tokatli@gmail.com"
LABEL description="Build123d development image with OCP dependencies and visualization"

# Arguments for Non-Root User
ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Install system dependencies
# - libgl1-mesa-glx & libglib2.0-0: Required for the OCP CAD kernel
# - git: Required for VS Code Dev Container features
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
		libgl1 \
		libglib2.0-0 \
		libxrender1 \
		git \
		sudo \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure Python Environment
# Debian Trixie may block global pip installs (PEP 668). 
# Since this is a container, we override this safety check.
ENV PIP_BREAK_SYSTEM_PACKAGES=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set OCP host default
ENV OCP_VSCODE_HOST=0.0.0.0

# 3. Install Python Packages
RUN python3 -m pip install --no-cache-dir \
    build123d \
    ocp-vscode \
	ipykernel \
	jupyter_client

# 4. Create Non-Root User
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME

EXPOSE 3939
