#!/bin/sh

# niri generates a default config on first run that blocks stow
rm -f "$HOME/.config/niri/config.kdl"

stow -t ~ nvim sway wezterm nushell starship wofi waybar niri ghostty mako alacritty zellij

THEMES_DIR="$HOME/.config/alacritty/themes"
if [ ! -d "$THEMES_DIR" ]; then
    git clone https://github.com/alacritty/alacritty-theme "$THEMES_DIR"
fi
