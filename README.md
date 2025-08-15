# Neovim Config (init.vim)

Personal Neovim configuration (Vimscript).

## Install (Linux)

```bash
mkdir -p ~/.config/nvim
# Optional: back up any existing config first
# cp -r ~/.config/nvim ~/.config/nvim.bak

# Install vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Start Neovim and install plugins
nvim +PlugInstall +qall
```

## Plugins
- `tpope/vim-surround`: add/change/delete surroundings quickly.
- `nvim-telescope/telescope.nvim` + `nvim-lua/plenary.nvim`: fuzzy finder.

Dependencies (Linux)
- `ripgrep` for `:Telescope live_grep` (e.g., `sudo apt install ripgrep`).

## Usage
- Leader is Space: `<leader>ff` files, `<leader>fg` grep, `<leader>fb` buffers, `<leader>fh` help.
- Surround basics: `ys{motion}{char}` add, `ds{char}` delete, `cs{from}{to}` change.
