# Use Ubuntu as the base image
FROM ubuntu:latest

# Prevent interactive timezone prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install essential build tools and compilers
RUN apt-get update && apt-get install -y \
    build-essential \
    clang \
    wget \
    unzip \
    time \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy current directory contents into the container
COPY . /app/

# Default command to keep the container running for interactive testing
CMD ["/bin/bash"]
