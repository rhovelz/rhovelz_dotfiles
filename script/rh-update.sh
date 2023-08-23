#!/bin/bash

sudo pacman -Sy

sudo pacman -Syyu --noconfirm
sudo paccache -r
sudo pacman -Rns $(pacman -Qdtq) --noconfirm
sudo rm -r /tmp/*

echo "System update, upgrade and cleaning complete!"
