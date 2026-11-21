-- Neovim options. Loaded before lazy.nvim.

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.autoread = true
vim.opt.scrolloff = 8
vim.opt.wrap = false

-- Restore editing layouts, not help windows, terminals, or empty dashboard panes.
vim.opt.sessionoptions = { 'buffers', 'curdir', 'folds', 'tabpages', 'winsize' }

-- Default indentation; override per language in after/ftplugin/<filetype>.lua.
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.g.autoformat = false

-- Set leaders before loading plugins so their mappings use the right keys.
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
