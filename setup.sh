#!/bin/env bash

# Check if the shell is bash
if [ -z "$BASH_VERSION" ]; then
  echo "This script is intended to be run in a bash shell."
  exit 1
fi

# Check if ~/.bash_aliases exists and is sourced by ~/.bashrc
if [ ! -f ~/.bash_aliases ]; then
  echo "~/.bash_aliases file does not exist. Creating it."
  touch ~/.bash_aliases
fi

if ! grep -q "if \[ -f ~/.bash_aliases \]; then . ~/.bash_aliases; fi" ~/.bashrc; then
  echo "~/.bash_aliases is not sourced by ~/.bashrc. Adding the source command."
  echo "if [ -f ~/.bash_aliases ]; then . ~/.bash_aliases; fi" >> ~/.bashrc
  source ~/.bashrc
fi

# Define the aliases
SGPT_ALIAS='alias sgpt="docker run --rm -it --user $(id -u):$(id -g) -e HOME=/home/$(whoami) -v $(pwd):/app/workdir -v ~/.config:/home/$(whoami)/.config --workdir /app/workdir shell-gpt"'
SGPT_HELP_ALIAS='alias sgpt-help="docker run --rm --user $(id -u):$(id -g) -e HOME=/home/$(whoami) -v $(pwd):/app/workdir -v ~/.config:/home/$(whoami)/.config --workdir /app/workdir --entrypoint glow shell-gpt -p /app/usage.md"'

# Explain what the script does
echo -e "\nThis script will add the following aliases to your ~/.bash_aliases file:\n"
echo -e "$SGPT_ALIAS"
echo -e "$SGPT_HELP_ALIAS"
echo -e "\nIt will also ensure that ~/.bash_aliases is sourced by your ~/.bashrc file.\n"

# Ask for confirmation
read -p "Do you want to proceed? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Operation cancelled."
  exit 1
fi

# Check if the aliases already exist in ~/.bash_aliases
if grep -q "alias sgpt=" ~/.bash_aliases; then
  echo "Alias 'sgpt' already exists in ~/.bash_aliases. Skipping addition."
else
  echo "$SGPT_ALIAS" >> ~/.bash_aliases
fi

if grep -q "alias sgpt-help=" ~/.bash_aliases; then
  echo "Alias 'sgpt-help' already exists in ~/.bash_aliases. Skipping addition."
else
  echo "$SGPT_HELP_ALIAS" >> ~/.bash_aliases
fi

# Source the ~/.bash_aliases to apply changes
source ~/.bash_aliases

echo "Aliases added and applied successfully."
