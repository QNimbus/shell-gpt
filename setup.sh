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

# Check if aliases file exists
if [ ! -f ./aliases ]; then
  echo "Aliases file not found. Please ensure the 'aliases' file is in the same directory as this script."
  exit 1
fi

# Explain what the script does
echo -e "\nThis script will add the following aliases to your ~/.bash_aliases file:\n"
cat ./aliases
echo -e "\nIt will also ensure that ~/.bash_aliases is sourced by your ~/.bashrc file.\n"

# Ask for confirmation
read -p "Do you want to proceed? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Operation cancelled."
  exit 1
fi

# Append the aliases to ~/.bash_aliases if they do not already exist
while IFS= read -r line; do
  # Skip empty lines and lines that contain only whitespace
  if [[ -z "$line" || "$line" =~ ^[[:space:]]*$ ]]; then
    continue
  fi

  if ! grep -q "$line" ~/.bash_aliases; then
    echo "$line" >> ~/.bash_aliases
  else
    echo -e "\nAlias '$line' already exists in ~/.bash_aliases. Skipping addition."
  fi
done < ./aliases

# Source the ~/.bash_aliases to apply changes
source ~/.bash_aliases

echo "Aliases added and functions copied successfully."
