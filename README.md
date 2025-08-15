# Neovim Config (init.vim)

Personal Neovim configuration (Vimscript).

## Install

If you already have a Neovim config, you may want to back it up first.

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

This repo expects `init.vim` at the root of your config directory (the path above).
