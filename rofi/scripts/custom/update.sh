#!/usr/bin/env bash

alacritty -e bash -i -c "echo 'Updating system...'; pacman -Syyu; exec bash"
