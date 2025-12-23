# Install Script Template

## I made this script mostly for personal use.

## Overview

This repository contains a comprehensive Bash script designed to facilitate the installation and configuration of personalized dotfiles on Arch Linux. The script performs two primary tasks in sequence:

1. **Package Installation** – Installs core, selected optional, and AUR packages required for the desired configuration.
2. **Configuration Transfer** – Transfers configuration files/folders to `~/.config/`, with automatic backups of existing configurations.


## How to use

Place the names of the packages that need installed into their relevant .txt. Arch Official Repository package names into core_pkgs.txt, Optional Package names into optional_pkgs.txt and Arch User Repository (AUR) package names into aur_pkgs.txt.

If you have a config from ~/.config/ that you want to use later, or if you are using someone elses dotfiles, copy the config folder to the config folder in this repository after cloned.


## Prerequisites

- Arch Linux (or an Arch-based distribution) with a working internet connection.
- `git` installed (required for cloning the dotfiles repository and installing `yay` if needed).
