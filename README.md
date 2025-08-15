# Neovim Config (init.vim)

Personal Neovim configuration (Vimscript). It focuses on readable defaults, 100‑column guide, 4‑space indents, sensible search/UI tweaks, and a handful of ergonomic mappings.

## Install

If you already have a Neovim config, back it up first.

Linux/macOS:
```bash
mkdir -p ~/.config/nvim
git clone https://github.com/<your-username>/<this-repo> ~/.config/nvim
```

Start Neovim: `nvim`

## Where Does Neovim Look For Config?

- In Neovim: `:echo stdpath('config')`
- Typical paths:
  - Linux/macOS: `~/.config/nvim`
  - Windows: `%LOCALAPPDATA%\nvim` (usually `C:\\Users\\<you>\\AppData\\Local\\nvim`)

This repo expects `init.vim` at the root of your config directory (the path above).
