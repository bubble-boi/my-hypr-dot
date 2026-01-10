*This is a personal setup, developed and tested on Fedora Linux.*

# setup

## 1. font install
```sh
cd /tmp
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/ProFont.zip
mkdir -p ~/.local/share/fonts/ProFont
unzip ProFont.zip -d ~/.local/share/fonts/ProFont
fc-cache -fv
```

## 2. backup configs
```sh
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
backup_or_remove ~/.local/share/wallpapers
backup_or_remove ~/.zshrc
backup_or_remove ~/.zprofile
```

## 3. symlink configs
```sh
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
```

## Installing the wonderful official Fedora wallpapers
```sh
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
```

