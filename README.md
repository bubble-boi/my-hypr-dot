# setup
```sh
mkdir -p ~/.config ~/.local/bin

mv ~/.config/hypr    ~/.config/hypr.bak    2>/dev/null
mv ~/.config/waybar  ~/.config/waybar.bak  2>/dev/null
mv ~/.config/wofi    ~/.config/wofi.bak    2>/dev/null
mv ~/.config/kitty   ~/.config/kitty.bak   2>/dev/null
mv ~/.config/swayimg ~/.config/swayimg.bak 2>/dev/null
mv ~/.local/bin/my-hypr-bin ~/.local/bin/my-hypr-bin.bak 2>/dev/null

ln -snf ~/my-hypr-dot/hypr        ~/.config/hypr
ln -snf ~/my-hypr-dot/waybar      ~/.config/waybar
ln -snf ~/my-hypr-dot/wofi        ~/.config/wofi
ln -snf ~/my-hypr-dot/kitty       ~/.config/kitty
ln -snf ~/my-hypr-dot/swayimg     ~/.config/swayimg
ln -snf ~/my-hypr-dot/my-hypr-bin ~/.local/bin/my-hypr-bin
