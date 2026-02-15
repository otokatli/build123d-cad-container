FROM debian:trixie-slim

# Set the locale
ENV LANG=C.UTF-8 \
	LC_ALL=C.UTF-8

SHELL ["/bin/bash", "-c"]

ARG DEBIAN_FRONTEND=noninteractive

# 1. Install system dependencies
# - libgl1-mesa-glx & libglib2.0-0: Required for the OCP CAD kernel
# - git: Required for VS Code Dev Container features
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
	&& apt-get upgrade -y \
    && apt-get -y install --no-install-recommends \
    libgl1 \
    libglib2.0-0 \
    libxrender1 \
	python3-dev \
	python3-pip \
	build-essential \
    git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Configure Python Environment
# Debian Trixie may block global pip installs (PEP 668). 
# Since this is a container, we override this safety check.
ENV PIP_BREAK_SYSTEM_PACKAGES=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 3. Install Python Packages
RUN python3 -m pip install --no-cache-dir \
    build123d \
    ocp-vscode

EXPOSE 3939

# 4. (Optional) Set OCP host default
ENV OCP_VSCODE_HOST=0.0.0.0
