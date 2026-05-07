#!/usr/bin/env bash

set -e

DOTFILES_DIR="$HOME/Workspace/dotfiles"

link_dir() {
    local src="$1"
    local dest="$2"

    echo "Linking $src -> $dest"

    backup_file "$dest"

    mkdir -p "$(dirname "$dest")"
    rm -rf "$dest"
    ln -s "$src" "$dest"
}

echo "Using DOTFILES_DIR = $DOTFILES_DIR"

### bashrc
# dotfiles/bash/bashrc -> ~/.bashrc
if [ -f "$DOTFILES_DIR/bash/bashrc" ]; then
    ln -sf "$DOTFILES_DIR/bash/bashrc" "$HOME/.bashrc"
fi

### Tmux
# dotfiles/tmux -> ~/.config/tmux
if [ -f "$DOTFILES_DIR/tmux/tmux.conf" ]; then
    ln -sf "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
fi

### Emacs
# dotfiles/emacs -> ~/.config/emacs
if [ -d "$DOTFILES_DIR/emacs.d" ]; then
    link_dir "$DOTFILES_DIR/emacs.d" "$HOME/.emacs.d"
fi

### Neovim
# dotfiles/nvim -> ~/.config/nvim
if [ -d "$DOTFILES_DIR/nvim" ]; then
    link_dir "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
fi

### i3
# dotfiles/i3 -> ~/.config/i3
if [ -d "$DOTFILES_DIR/i3" ]; then
    link_dir "$DOTFILES_DIR/i3" "$HOME/.config/i3"
fi

### i3status
# dotfiles/i3status -> ~/.config/i3status
if [ -d "$DOTFILES_DIR/i3status" ]; then
    link_dir "$DOTFILES_DIR/i3status" "$HOME/.config/i3status"
fi

### alacritty
# dotfiles/alacritty -> ~/.config/alacritty
if [ -d "$DOTFILES_DIR/alacritty" ]; then
    link_dir "$DOTFILES_DIR/alacritty" "$HOME/.config/alacritty"
fi

### mpv
# dotfiles/mpv -> ~/.config/mpv
if [ -d "$DOTFILES_DIR/mpv" ]; then
    link_dir "$DOTFILES_DIR/mpv" "$HOME/.config/mpv"
fi

### scripts
# dotfiles/scripts -> ~/.config/scripts
if [ -d "$DOTFILES_DIR/scripts" ]; then
    link_dir "$DOTFILES_DIR/scripts" "$HOME/.config/scripts"

    chmod +x "$DOTFILES_DIR"/scripts/*.sh 2>/dev/null || true
    chmod +x "$HOME"/.config/scripts/*.sh 2>/dev/null || true
fi

### sway
# dotfiles/sway -> ~/.config/sway
if [ -d "$DOTFILES_DIR/sway" ]; then
    link_dir "$DOTFILES_DIR/sway" "$HOME/.config/sway"
fi

### waybar
# dotfiles/waybar -> ~/.config/waybar
if [ -d "$DOTFILES_DIR/waybar" ]; then
    link_dir "$DOTFILES_DIR/waybar" "$HOME/.config/waybar"
fi

### foot
# dotfiles/foot -> ~/.config/foot
if [ -d "$DOTFILES_DIR/foot" ]; then
    link_dir "$DOTFILES_DIR/foot" "$HOME/.config/foot"
fi

echo "All done!"

