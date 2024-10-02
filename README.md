# Shell-GPT Docker Image

This repository contains a Dockerfile to build a Docker image for Shell-GPT, which includes the `glow` binary and necessary Python packages.

## Table of Contents
- [Building the Docker Image](#building-the-docker-image)
  - [Using `build.sh`](#using-buildsh)
  - [Using `docker build`](#using-docker-build)
- [Running the Docker Container](#running-the-docker-container)
- [Setting Up Aliases](#setting-up-aliases)
  - [Running `setup.sh`](#running-setupsh)
  - [Aliases Created](#aliases-created)
  - [Customizing Aliases](#customizing-aliases)
- [Usage](#usage)
- [Example](#example)
- [Related Content](#related-content)

## Building the Docker Image

You can build the Docker image using the provided `build.sh` script or by running the `docker build` command directly.

### Using `build.sh`

To build the Docker image using the `build.sh` script, run the following commands in the directory containing the script:

```sh
chmod +x build.sh
./build.sh
```

### Using `docker build`

Alternatively, you can build the Docker image by running the following command in the directory containing the Dockerfile:

```sh
docker build -t shell-gpt .
```

## Running the Docker Container

To run the Docker container, use the following command:

```sh
docker run -it --rm shell-gpt
```

## Setting Up Aliases

To add the necessary aliases to your environment, you need to run the `setup.sh` script. This script will configure your shell to use the `sgpt` command.

### Running `setup.sh`

1. Ensure the `setup.sh` script is executable:

    ```sh
    chmod +x setup.sh
    ```

2. Source the `setup.sh` script:

    ```sh
    source ./setup.sh
    ```

This will add the required aliases to your environment, allowing you to use the `sgpt` command.

### Aliases Created

The `setup.sh` script reads the aliases from the `aliases` file and adds them to your `~/.bash_aliases` file:

- **sgpt**: Runs the Shell-GPT Docker container with the current directory mounted as the working directory and the user's configuration directory mounted for persistence.

    ```sh
    alias sgpt="docker run --rm -it --user $(id -u):$(id -g) -e HOME=/home/$(whoami) -v $(pwd):/app/workdir -v ~/.config:/home/$(whoami)/.config --workdir /app/workdir shell-gpt"
    ```

- **sgpt-help**: Runs the `glow` binary inside the Shell-GPT Docker container to display the `usage.md` file.

    ```sh
    alias sgpt-help="docker run --rm --user $(id -u):$(id -g) -e HOME=/home/$(whoami) -e TERM=xterm-256color -v $(pwd):/app/workdir -v ~/.config:/home/$(whoami)/.config --workdir /app/workdir --entrypoint glow shell-gpt -s dark -p /app/usage.md"
    ```

### Customizing Aliases

You can customize these aliases by editing the `aliases` file. For example, if you want to change the working directory or add additional volume mounts, you can modify the `docker run` command in the alias definition.

After making changes to `~/.bash_aliases`, run the following command to apply the changes:

```sh
source ~/.bash_aliases
```

## Usage

Once the setup is complete, you can use the `sgpt` command to interact with Shell-GPT. For more information on how to use Shell-GPT, refer to the `usage.md` file included in the Docker image.

## Example

```sh
sgpt "What is the capital of France?"
```

This command will use Shell-GPT to provide an answer to your query.

## Related Content

- [Shell-GPT on PyPI](https://pypi.org/project/shell-gpt/)
- [Shell-GPT Documentation](https://github.com/TheR1D/shell_gpt#readme)
