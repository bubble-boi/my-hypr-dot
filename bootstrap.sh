#!/usr/bin/env bash
set -e

# package install
sudo dnf install -y \
power-profiles-daemon \
zsh \
fcitx5 fcitx5-mozc fcitx5-gtk fcitx5-qt \
hyprland hyprpaper hyprlock hypridle hyprsunset \
waybar \
swayimg \
spotifyd playerctl \
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
dnf-plugins-core

#install font
cd /tmp
curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/ProFont.zip
mkdir -p ~/.local/share/fonts/ProFont
unzip -oq ProFont.zip -d ~/.local/share/fonts/ProFont
rm -f ProFont.zip

# dots
mkdir -p ~/.config \
         ~/.local/{bin,state} \
         ~/.config/fontconfig/conf.d

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
ln -snf ~/mi-hydora-dot/wallpapers \
        ~/.local/share/wallpapers
ln -snf ~/mi-hydora-dot/.zshrc \
        ~/.zshrc
ln -snf ~/mi-hydora-dot/.zprofile \
        ~/.zprofile
ln -snf ~/mi-hydora-dot/fontconfig/conf.d/60-ja-hydora.conf \
        ~/.config/fontconfig/conf.d/60-ja-hydora.conf

fc-cache -fv

# install wallpaper
cd
mkdir -p ~/fedora-background-rpms && cd ~/fedora-background-rpms && \
dnf download --resolve 'f*-backgrounds-base' 'f*-backgrounds-animated' 'f*-backgrounds-extras-base' && \
mkdir -p extracted && \
for rpm in *.rpm; do \
  rpm2cpio "$rpm" | cpio -idmv -D extracted; \
done && \
for d in "" "/default/normalish/" "/default/standard/" "/default/wide/" "/default/tv-wide/"; do
  find extracted/usr/share/backgrounds \
    -type f -path "*$d*" \
      \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' -o -iname '*.jxl' \) \
    -exec cp -f -- {} "$HOME/.local/share/wallpapers" \;
done
rm -rf ~/fedora-background-rpms
