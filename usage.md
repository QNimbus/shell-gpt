# Shell-GPT Command Line Usage Guide

## Overview
Shell-GPT (`sgpt`) is a command-line tool powered by large language models, designed to assist with generating shell commands, code snippets, and more.

## Commands and Features

### 1. Generate Shell Command
Generate and execute shell commands.
```sh
sgpt --shell "find all json files in current folder"
sgpt --shell "list all running processes"
```

### 2. Generate Code
Generate code snippets for various programming tasks.
```sh
sgpt --code "solve fizz buzz problem using python"
sgpt --code "create a function to reverse a string in JavaScript"
```

### 3. Chat Mode
Maintain a conversational dialogue with the model.
```sh
sgpt --chat conversation_1 "please remember my favorite number: 4"
sgpt --chat conversation_1 "what is my favorite number?"
```

### 4. REPL Mode
Interactive Read-Eval-Print Loop for real-time interaction.
```sh
sgpt --repl temp
```

### 5. Function Calling
Execute custom functions defined in your system.
```sh
sgpt --function "my_custom_function"
```

## Configuration
Configure `shell-gpt` using a runtime configuration file located at `~/.config/shell_gpt/.sgptrc`. Set parameters like API key, default model, cache settings, and more.

For more detailed information, visit the [shell-gpt PyPI page](https://pypi.org/project/shell-gpt/).
