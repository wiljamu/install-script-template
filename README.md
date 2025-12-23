# Install Script Template

## I made this script mostly for personal use.

## Overview

This repository contains a comprehensive Bash script designed to facilitate the installation and configuration of personalized dotfiles on Arch Linux. The script performs two primary tasks in sequence:

1. **Package Installation** – Installs core, selected optional, and AUR packages required for the desired configuration.
2. **Configuration Transfer** – Transfers configuration files/folders to `~/.config/`, with automatic backups of existing configurations.


## How to use

Place the names of the packages that need installed into their relevant .txt. Arch Official Repository package names into 

### core_pkgs.txt
Place the names of core packages here. 

### optional_pkgs.txt 
Place the names of optional packages here. 

### aur_pkgs.txt.
Place the names of Arch User Repository (AUR) package here.

Place any configs into the config folder.


## Prerequisites

- Arch Linux (or an Arch-based distribution) with a working internet connection.
- `git` installed (required for cloning the dotfiles repository and installing `yay` if needed).
