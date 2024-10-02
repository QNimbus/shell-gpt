#!/bin/env bash

# Check if the shell is bash
if [ -z "$BASH_VERSION" ]; then
  echo "This script is intended to be run in a bash shell."
  exit 1
fi

# Check if script is sourced
if [ "$0" = "$BASH_SOURCE" ]; then
  echo "This script is intended to be sourced, not executed."
  echo
  echo "Example usage: source ./setup.sh"
  exit 1
fi

# Parse command line arguments
FORCE=false
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -f|--force) FORCE=true ;;
    *) echo "Unknown parameter passed: $1"; exit 1 ;;
  esac
  shift
done

# Truncate ~/.bash_aliases if --force is provided
if [ "$FORCE" = true ]; then
  > ~/.bash_aliases
  echo "~/.bash_aliases has been truncated."
fi

# Copy functions to ~/.config/shell_gpt/functions
FUNCTIONS_DIR="$HOME/.config/shell_gpt/functions"
mkdir -p "$FUNCTIONS_DIR"
cp -r ./functions/* "$FUNCTIONS_DIR"

# Check if ~/.bash_aliases exists and is sourced by ~/.bashrc
if [ ! -f ~/.bash_aliases ]; then
  echo "~/.bash_aliases file does not exist. Creating it."
  touch ~/.bash_aliases
fi

if ! grep -q ". ~/.bash_aliases" ~/.bashrc; then
  echo "~/.bash_aliases is not sourced by ~/.bashrc. Adding the source command."
  echo "if [ -f ~/.bash_aliases ]; then . ~/.bash_aliases; fi" >> ~/.bashrc
  source ~/.bashrc
fi

# Define aliases using indexed arrays
alias_names=("sgpt" "chat" "sgpt-debug" "sgpt-help" "sgpt-clear-chat")
alias_commands=(
  "docker run --rm -it --user $(id -u):$(id -g) -e SHELL_NAME=$SHELL -e HOME=/home/$(whoami) -e TERM=xterm-256color -v gpt-cache:/tmp/chat_cache -v $(pwd):/app/workdir -v ~/:/home/$(whoami) shell-gpt"
  "docker run --rm -it --user $(id -u):$(id -g) -e SHELL_NAME=$SHELL -e HOME=/home/$(whoami) -e TERM=xterm-256color -v gpt-cache:/tmp/chat_cache -v $(pwd):/app/workdir -v ~/:/home/$(whoami) shell-gpt --chat sgpt-chat"
  "docker run --rm -it --user $(id -u):$(id -g) -e SHELL_NAME=$SHELL -e HOME=/home/$(whoami) -e TERM=xterm-256color -v gpt-cache:/tmp/chat_cache -v $(pwd):/app/workdir -v ~/:/home/$(whoami) --entrypoint /bin/bash shell-gpt"
  "docker run --rm -it --user $(id -u):$(id -g) -e HOME=/home/$(whoami) -e TERM=xterm-256color -v ~/:/home/$(whoami) --entrypoint glow shell-gpt --style dark --pager /app/usage.md"
  "docker volume rm gpt-cache && echo 'Chat cache cleared.'"
)

# Append the aliases to ~/.bash_aliases if they do not already exist
for i in "${!alias_names[@]}"; do
  alias_command="alias ${alias_names[$i]}=\"${alias_commands[$i]}\""
  if ! grep -Fq "$alias_command" ~/.bash_aliases; then
    echo "$alias_command" >> ~/.bash_aliases
  else
    echo -e "\nAlias '$alias_command' already exists in ~/.bash_aliases. Skipping addition."
  fi
done

# Source the ~/.bash_aliases to apply changes
source ~/.bash_aliases

echo "Aliases added and functions copied successfully."
echo
echo "Note: Consider running the following commands:"
echo
echo "sgpt --install-functions"
echo "sgpt --install-integration"
