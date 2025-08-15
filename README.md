# Neovim Config (init.vim)

Personal Neovim configuration (Vimscript). It focuses on readable defaults, 100‑column guide, 4‑space indents, sensible search/UI tweaks, and a handful of ergonomic mappings.

## Install

If you already have a Neovim config, back it up first.

Linux/macOS:
```bash
mkdir -p ~/.config/nvim
git clone https://github.com/<your-username>/<this-repo> ~/.config/nvim
```

Windows (PowerShell):
```powershell
New-Item -Force -ItemType Directory $env:LOCALAPPDATA\nvim | Out-Null
git clone https://github.com/<your-username>/<this-repo> $env:LOCALAPPDATA\nvim
```

Start Neovim: `nvim`

## Where Does Neovim Look For Config?

- In Neovim: `:echo stdpath('config')`
- Typical paths:
  - Linux/macOS: `~/.config/nvim`
  - Windows: `%LOCALAPPDATA%\nvim` (usually `C:\\Users\\<you>\\AppData\\Local\\nvim`)

This repo expects `init.vim` at the root of your config directory (the path above).

## What’s Inside (brief)

- Line numbers (absolute + relative), no soft wrap, 100‑column ruler.
- Indentation: 4 spaces (`expandtab`, `shiftwidth=4`, `tabstop=4`).
- Search/UI: `ignorecase` + `smartcase`, incremental/hlsearch, `signcolumn=yes`, `termguicolors`.
- Clipboard/mouse: system clipboard by default, mouse enabled.
- Persistent undo (`undofile`).
- Mappings: `<Space>` as leader; quick save/quit, window moves with `<C-h/j/k/l>`, buffer next/prev, clear search, etc.

No plugin manager is required; this is plain Neovim with QoL settings and mappings.
