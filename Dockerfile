# Base image
FROM python:3.9-slim

# Set build argument for glow version
ARG GLOW_VERSION="2.0.0"

# Set working directory
RUN mkdir -p /app/workdir
WORKDIR /app/workdir

# Install necessary tools
RUN apt update && apt install -y gnupg git wget

ENV TERM=xterm-256color

# Define filename variables
ENV GLOW_VERSIONED_FILENAME="glow_${GLOW_VERSION}_Linux_x86_64"
ENV GLOW_ARCHIVE_FILENAME="${GLOW_VERSIONED_FILENAME}.tar.gz"
ENV GLOW_CHECKSUM_FILENAME="checksums.txt"

# Download glow binary and checksums
RUN wget "https://github.com/charmbracelet/glow/releases/download/v${GLOW_VERSION}/${GLOW_ARCHIVE_FILENAME}" && \
    wget "https://github.com/charmbracelet/glow/releases/download/v${GLOW_VERSION}/${GLOW_CHECKSUM_FILENAME}"

# Verify glow binary
RUN grep "${GLOW_ARCHIVE_FILENAME}$" ${GLOW_CHECKSUM_FILENAME} > glow_checksum.txt && \
    sha256sum -c glow_checksum.txt && \
    tar -xzf "${GLOW_ARCHIVE_FILENAME}" && \
    mv "${GLOW_VERSIONED_FILENAME}/glow" /usr/local/bin/glow && \
    rm -rf "${GLOW_VERSIONED_FILENAME}" "${GLOW_ARCHIVE_FILENAME}" "${GLOW_CHECKSUM_FILENAME}" glow_checksum.txt

# Install Python packages
RUN pip install --no-cache-dir shell-gpt

# Add usage.md to the image
ADD usage.md /app/usage.md

# Entrypoint for sgpt
ENTRYPOINT ["sgpt"]
