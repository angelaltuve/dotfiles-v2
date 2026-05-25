# 🏡 Dotfiles — Angel Altuve

[🇪🇸 Español](README.es.md)

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)

My personal Linux configurations, managed with **GNU Stow**.

![Screenshot](assets/screenshot.png)

## 📁 Structure

Each program lives in its own directory and gets deployed via Stow:

```
.dotfiles/
├── alacritty/   →  ~/.config/alacritty
├── sway/        →  ~/.config/sway
├── nvim/        →  ~/.config/nvim
├── zsh/         →  ~/.config/zsh
├── waybar/      →  ~/.config/waybar
├── home/        →  ~/.zshenv
└── ...
```

## 🚀 Installation

### Dependencies

```bash
# Arch Linux
pacman -S stow alacritty sway waybar rofi mako foot kitty imv yazi zsh tmux neovim sc-im gtk3 gtk4 qt5ct qt6ct fontconfig yt-dlp aria2 wget newsboat podboat rmpc mpv pandoc lazygit calcurse btop htop fastfetch eza zathura

# Debian / Ubuntu
apt install stow alacritty sway waybar rofi mako foot kitty imv zsh tmux neovim gtk3 gtk4 qt5ct qt6ct fontconfig yt-dlp aria2 wget newsboat podboat mpv pandoc lazygit calcurse btop htop fastfetch eza zathura

# Fedora
dnf install stow alacritty sway waybar rofi mako foot kitty imv zsh tmux neovim gtk3 gtk4 qt5ct qt6ct fontconfig yt-dlp aria2 wget newsboat podboat mpv pandoc lazygit calcurse btop htop fastfetch eza zathura
```

> Some packages like `yazi`, `sc-im`, `rmpc`, `paru` and `yay` may require AUR, COPR or manual installation.

### Deploy

```bash
git clone git@github.com:angelaltuve/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow */
```

## 📦 Included packages

| Category | Apps |
|----------|------|
| **WM/UI** | Sway, Waybar, Rofi, Mako, Foot, Alacritty, Kitty, IMV, Yazi |
| **Shell** | Zsh, Tmux, Shell scripts |
| **Editors** | Neovim, SC-IM |
| **GTK/Qt** | GTK3/4, Qt5ct, Qt6ct, Fontconfig |
| **Downloads** | yt-dlp, Aria2, Wget, Newsboat, Podboat, RMPC, MPV |
| **Dev** | Pandoc, Lazygit, Mise, Calcurse |
| **AUR** | Paru, Yay |
| **System** | Btop, Htop, Fastfetch, Eza, Zathura |
