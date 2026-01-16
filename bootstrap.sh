#!/usr/bin/env bash


# Bootstrap script for my personal Fedora + Hyprland environment
# This script is destructive and may overwrite existing configs.

set -e

# Backup existing configs (symlinks are removed, files are timestamped)
ts=$(date +%Y%m%d-%H%M%S)

backup_or_remove () {
  local p="$1"
  if [ -L "$p" ]; then
    rm -f "$p"
  elif [ -e "$p" ]; then
    mv "$p" "$p.bak.$ts"
  fi
}

backup_or_remove ~/.config/hypr
backup_or_remove ~/.config/waybar
backup_or_remove ~/.config/wofi
backup_or_remove ~/.config/alacritty
backup_or_remove ~/.config/swayimg
backup_or_remove ~/.config/fcitx5
backup_or_remove ~/.config/nvim
backup_or_remove ~/.config/zsh
backup_or_remove ~/.config/fastfetch
backup_or_remove ~/.config/tmux
backup_or_remove ~/.config/mako
backup_or_remove ~/.config/systemd/user/spotifyd.service
backup_or_remove ~/.local/share/wallpapers
backup_or_remove ~/.zshrc
backup_or_remove ~/.zprofile

# Create required directories
mkdir -p ~/.config \
         ~/.local/{bin,state} \
         ~/.config/fontconfig/conf.d \
         ~/.config/systemd/user

# Install required packages via dnf
sudo dnf install -y \
power-profiles-daemon \
zsh \
fcitx5 mozc \
hyprland hyprpaper hyprlock hypridle hyprsunset \
waybar \
swayimg \
playerctl \
neovim \
tesseract \
wf-recorder \
fastfetch \
fd \
bat \
alacritty \
ripgrep \
grim \
slurp \
hyprpicker \
cliphist \
wl-clipboard \
wofi \
curl \
unzip \
cpio \
dnf-plugins-core rpm-build \
python3

# Install ProFont (Nerd Font)
cd /tmp
curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/ProFont.zip
mkdir -p ~/.local/share/fonts/ProFont
unzip -oq ProFont.zip -d ~/.local/share/fonts/ProFont
rm -f ProFont.zip

# Install spotifyd binary and enable user service
cd ~/.local/bin
curl -LO https://github.com/Spotifyd/spotifyd/releases/latest/download/spotifyd-linux-x86_64-default.tar.gz
tar xzf spotifyd-linux-x86_64-default.tar.gz
chmod +x spotifyd
rm spotifyd-linux-x86_64-default.tar.gz

# Symlink dotfiles into $HOME
ln -snf ~/mi-hydora-dot/hypr \
        ~/.config/hypr
ln -snf ~/mi-hydora-dot/waybar \
        ~/.config/waybar
ln -snf ~/mi-hydora-dot/wofi \
        ~/.config/wofi
ln -snf ~/mi-hydora-dot/alacritty \
        ~/.config/alacritty
ln -snf ~/mi-hydora-dot/swayimg \
        ~/.config/swayimg
ln -snf ~/mi-hydora-dot/fcitx5 \
        ~/.config/fcitx5
ln -snf ~/mi-hydora-dot/nvim \
        ~/.config/nvim
ln -snf ~/mi-hydora-dot/zsh \
        ~/.config/zsh
ln -snf ~/mi-hydora-dot/fastfetch \
        ~/.config/fastfetch
ln -snf ~/mi-hydora-dot/tmux \
        ~/.config/tmux
ln -snf ~/mi-hydora-dot/mako \
        ~/.config/mako
ln -snf ~/mi-hydora-dot/systemd/user/spotifyd.service \
        ~/.config/systemd/user/spotifyd.service
ln -snf ~/mi-hydora-dot/wallpapers \
        ~/.local/share/wallpapers
ln -snf ~/mi-hydora-dot/.zshrc \
        ~/.zshrc
ln -snf ~/mi-hydora-dot/.zprofile \
        ~/.zprofile
ln -snf ~/mi-hydora-dot/fontconfig/conf.d/60-ja-hydora.conf \
        ~/.config/fontconfig/conf.d/60-ja-hydora.conf

# Rebuild font cache
fc-cache -fv

# Enable services
systemctl --user daemon-reload
systemctl --user enable --now spotifyd
sudo systemctl enable --now power-profiles-daemon

# Installing the wonderful official Fedora wallpapers
mkdir -p /tmp/fedora-background-rpms && cd /tmp/fedora-background-rpms && \
dnf download --resolve 'f*-backgrounds-base' 'f*-backgrounds-animated' 'f*-backgrounds-extras-base' && \
mkdir -p extracted && \
for rpm in *.rpm; do \
  rpm2cpio "$rpm" | cpio -idmv -D extracted; \
done && \
for d in "" "/default/normalish/" "/default/standard/" "/default/wide/" "/default/tv-wide/"; do \
  find extracted/usr/share/backgrounds \
    -type f -path "*$d*" \
      \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' -o -iname '*.jxl' \) \
    -exec cp -f -- {} "$HOME/.local/share/wallpapers" \;
done
rm -rf /tmp/fedora-background-rpms
